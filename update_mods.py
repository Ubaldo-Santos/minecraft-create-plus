#!/usr/bin/env python3
"""
update_mods.py - Sincroniza los mods del servidor con el pack Create+.

Uso:
    python3 update_mods.py          # Ver cambios sin modificar nada
    python3 update_mods.py --apply  # Aplicar cambios al Dockerfile
"""

import json
import re
import sys
import urllib.request
import zipfile
import io
import os
from pathlib import Path

MODRINTH_PROJECT_ID = "t1tOiUHZ"   # Create+ en Modrinth
MODRINTH_API = f"https://api.modrinth.com/v2/project/{MODRINTH_PROJECT_ID}/version"
DOCKERFILE_PATH = Path(__file__).parent / "Dockerfile"

# Mods añadidos manualmente al servidor (nunca se eliminan al sincronizar).
SERVER_ONLY_MODS: set[str] = set()


def fetch_json(url):
    req = urllib.request.Request(url, headers={"User-Agent": "minecraft-server-updater/1.0"})
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())


def get_latest_version(mc_version: str):
    """Devuelve el objeto version más reciente del pack para la versión de MC dada."""
    versions = fetch_json(MODRINTH_API)
    for v in versions:
        if mc_version in v.get("game_versions", []):
            # La API devuelve versiones de más reciente a más antigua
            for f in v.get("files", []):
                if f["filename"].endswith(".mrpack"):
                    return v, f
    raise RuntimeError(f"No se encontró versión del pack para MC {mc_version}")


def download_mrpack(url: str) -> bytes:
    print(f"  Descargando {url.split('/')[-1]}...")
    req = urllib.request.Request(url, headers={"User-Agent": "minecraft-server-updater/1.0"})
    with urllib.request.urlopen(req) as resp:
        return resp.read()


def parse_mrpack(data: bytes) -> list[dict]:
    """Retorna lista de {filename, url, env_server} del modrinth.index.json."""
    with zipfile.ZipFile(io.BytesIO(data)) as z:
        with z.open("modrinth.index.json") as f:
            index = json.load(f)
    result = []
    for entry in index["files"]:
        if not entry["downloads"] or not entry["path"].startswith("mods/"):
            continue
        server_env = entry.get("env", {}).get("server", "required")
        if server_env == "unsupported":
            continue  # client-only, ignorar
        result.append({
            "filename": os.path.basename(entry["path"]),
            "url": entry["downloads"][0],
        })
    return result


def extract_mc_version(dockerfile_path: Path) -> str:
    content = dockerfile_path.read_text()
    m = re.search(r'ARG MC_VERSION=(\S+)', content)
    if not m:
        raise RuntimeError("No se encontró ARG MC_VERSION en el Dockerfile")
    return m.group(1)


def extract_current_mods(dockerfile_path: Path) -> dict[str, str]:
    """Extrae {filename: url} de todos los curl en el Dockerfile."""
    content = dockerfile_path.read_text()
    pattern = re.compile(r'curl -sSL -o "mods/([^"]+)"\s*\\\s*\n\s*"([^"]+)"')
    return {m.group(1): m.group(2) for m in pattern.finditer(content)}


def is_server_only(filename: str) -> bool:
    return any(filename.startswith(prefix) for prefix in SERVER_ONLY_MODS)


def mod_base_name(filename: str) -> str:
    name = filename.replace(".jar", "")
    for sep in ["-mc", "+mc", "-MC", "-neoforge", "-NEOFORGE", "-forge", "-fabric"]:
        name = name.split(sep)[0]
    name = re.sub(r'[-_]\d+\.\d+.*$', '', name)
    return name.lower()


def main():
    apply = "--apply" in sys.argv

    print("=== Actualizador de mods del servidor Create+ ===\n")

    if not DOCKERFILE_PATH.exists():
        print(f"ERROR: No se encontró {DOCKERFILE_PATH}")
        sys.exit(1)

    mc_version = extract_mc_version(DOCKERFILE_PATH)
    print(f"Versión MC del servidor: {mc_version}")

    print(f"Buscando versión más reciente del pack en Modrinth...")
    version, mrpack_file = get_latest_version(mc_version)
    print(f"Versión encontrada: {version['version_number']} ({mrpack_file['filename']})\n")

    mrpack_data = download_mrpack(mrpack_file["url"])
    pack_mods = parse_mrpack(mrpack_data)

    # Lookup {base_name: (filename, url)}
    pack_lookup = {mod_base_name(m["filename"]): (m["filename"], m["url"]) for m in pack_mods}

    current_mods = extract_current_mods(DOCKERFILE_PATH)

    updates = []   # (old_file, old_url, new_file, new_url)
    skipped = []

    for server_file, server_url in sorted(current_mods.items()):
        if is_server_only(server_file):
            continue
        base = mod_base_name(server_file)
        if base in pack_lookup:
            new_file, new_url = pack_lookup[base]
            if new_file != server_file or new_url != server_url:
                updates.append((server_file, server_url, new_file, new_url))
            else:
                skipped.append(server_file)
        else:
            skipped.append(server_file)

    if updates:
        print("CAMBIOS A APLICAR")
        print("-" * 60)
        for old_f, old_u, new_f, new_u in updates:
            if old_f != new_f:
                print(f"  RENAME: {old_f}")
                print(f"      ->  {new_f}")
            else:
                print(f"  UPDATE: {old_f}")
            if old_u != new_u:
                print(f"       URL nueva: ...{new_u[-60:]}")
            print()
    else:
        print("El servidor ya está al día con el pack.\n")

    print(f"Sin cambios: {len(skipped)} mods")
    print(f"Server-only (intocables): {sum(1 for f in current_mods if is_server_only(f))} mods")

    if not updates:
        return

    if not apply:
        print(f"\nPara aplicar los cambios ejecuta:")
        print(f"  python3 {__file__} --apply")
        return

    print("\nAplicando cambios al Dockerfile...")
    content = DOCKERFILE_PATH.read_text()

    for old_f, old_u, new_f, new_u in updates:
        old_block = f'curl -sSL -o "mods/{old_f}" \\\n        "{old_u}"'
        new_block = f'curl -sSL -o "mods/{new_f}" \\\n        "{new_u}"'
        if old_block in content:
            content = content.replace(old_block, new_block)
            print(f"  OK: {old_f}" + (f" -> {new_f}" if old_f != new_f else ""))
        else:
            print(f"  WARN: No se encontró el bloque para {old_f}")

    DOCKERFILE_PATH.write_text(content)
    print(f"\nDockerfile actualizado. Reconstruye la imagen:")
    print("  docker compose build --no-cache")
    print("  docker compose up -d")


if __name__ == "__main__":
    main()
