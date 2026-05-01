# =============================================================================
# Minecraft Create+ Server - Custom Build
# MC 1.21.1 | NeoForge 21.1.228 | Create+ 6.0.0 Early Alpha D
# =============================================================================
# Compatible with Dokploy deployment
# =============================================================================

FROM eclipse-temurin:21-jre AS builder

WORKDIR /build

ARG MC_VERSION=1.21.1
ARG NEOFORGE_VERSION=21.1.228

RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

# Install NeoForge server
RUN curl -sSL -o neoforge-installer.jar \
    "https://maven.neoforged.net/releases/net/neoforged/neoforge/${NEOFORGE_VERSION}/neoforge-${NEOFORGE_VERSION}-installer.jar" && \
    java -jar neoforge-installer.jar --install-server . && \
    rm neoforge-installer.jar

# Download server-compatible mods (95 mods, client-only excluded)
RUN mkdir -p mods && \
    curl -sSL -o "mods/aileron-1.21.1-neoforge-1.1.4.jar" \
        "https://cdn.modrinth.com/data/b8kG1VGq/versions/XDz1C9KI/aileron-1.21.1-neoforge-1.1.4.jar" && \
    curl -sSL -o "mods/alloyed-3.0.8+1.21.1-neoforge.jar" \
        "https://cdn.modrinth.com/data/KUInlTFo/versions/p0ZgNPlj/alloyed-3.0.8%2B1.21.1-neoforge.jar" && \
    curl -sSL -o "mods/alternate_current-mc1.21-1.9.0.jar" \
        "https://cdn.modrinth.com/data/r0v8vy1s/versions/PCNyL6v4/alternate_current-mc1.21-1.9.0.jar" && \
    curl -sSL -o "mods/amendments-1.21-2.0.15-neoforge.jar" \
        "https://cdn.modrinth.com/data/6iTJugQR/versions/8xf6Wpxs/amendments-1.21-2.0.15-neoforge.jar" && \
    curl -sSL -o "mods/another_furniture-neoforge-4.0.2.jar" \
        "https://cdn.modrinth.com/data/ulloLmqG/versions/Q29JlZfU/another_furniture-neoforge-4.0.2.jar" && \
    curl -sSL -o "mods/appleskin-neoforge-mc1.21-3.0.9.jar" \
        "https://cdn.modrinth.com/data/EsAfCjCV/versions/uAKA6Laj/appleskin-neoforge-mc1.21-3.0.9.jar" && \
    curl -sSL -o "mods/architectury-13.0.8-neoforge.jar" \
        "https://cdn.modrinth.com/data/lhGA9TYQ/versions/ZxYGwlk0/architectury-13.0.8-neoforge.jar" && \
    curl -sSL -o "mods/ArmorStatues-v21.1.0-1.21.1-NeoForge.jar" \
        "https://cdn.modrinth.com/data/bbGCtEvb/versions/SGpwIu7v/ArmorStatues-v21.1.0-1.21.1-NeoForge.jar" && \
    curl -sSL -o "mods/AxesAreWeapons-1.9.2-neoforge-1.21.jar" \
        "https://cdn.modrinth.com/data/1jvt7RTc/versions/UVPAidip/AxesAreWeapons-1.9.2-neoforge-1.21.jar" && \
    curl -sSL -o "mods/balm-neoforge-1.21.1-21.0.57.jar" \
        "https://cdn.modrinth.com/data/MBAkmtvl/versions/XC1JUHmA/balm-neoforge-1.21.1-21.0.57.jar" && \
    curl -sSL -o "mods/bellsandwhistles-0.4.7-1.21.1.jar" \
        "https://cdn.modrinth.com/data/gJ5afkVv/versions/w0mifib8/bellsandwhistles-0.4.7-1.21.1.jar" && \
    curl -sSL -o "mods/bits_n_bobs-0.0.44.jar" \
        "https://cdn.modrinth.com/data/T8bvmqVZ/versions/XKDQlGJW/bits_n_bobs-0.0.44.jar" && \
    curl -sSL -o "mods/bookshelf-neoforge-1.21.1-21.1.81.jar" \
        "https://cdn.modrinth.com/data/uy4Cnpcm/versions/1sdJl7J1/bookshelf-neoforge-1.21.1-21.1.81.jar" && \
    curl -sSL -o "mods/c2me-neoforge-mc1.21.1-0.3.0+alpha.0.91.jar" \
        "https://cdn.modrinth.com/data/COlSi5iR/versions/9iPiN34N/c2me-neoforge-mc1.21.1-0.3.0%2Balpha.0.91.jar" && \
    curl -sSL -o "mods/carryon-neoforge-1.21.1-2.2.4.4.jar" \
        "https://cdn.modrinth.com/data/joEfVgkn/versions/cgZi7nC7/carryon-neoforge-1.21.1-2.2.4.4.jar" && \
    curl -sSL -o "mods/cerulean-neoforge-1.0.0-1.21.1.jar" \
        "https://cdn.modrinth.com/data/dv57xmf9/versions/i5PXO3P7/cerulean-neoforge-1.0.0-1.21.1.jar" && \
    curl -sSL -o "mods/cloth-config-15.0.140-neoforge.jar" \
        "https://cdn.modrinth.com/data/9s6osm5g/versions/izKINKFg/cloth-config-15.0.140-neoforge.jar" && \
    curl -sSL -o "mods/Companion-1.21.1-NeoForge-6.1.1.jar" \
        "https://cdn.modrinth.com/data/4w0EzGRW/versions/eOB43rJ0/Companion-1.21.1-NeoForge-6.1.1.jar" && \
    curl -sSL -o "mods/ConfiguredDefaults-v21.1.3-1.21.1-NeoForge.jar" \
        "https://cdn.modrinth.com/data/SISoSFPP/versions/HJxTPhTM/ConfiguredDefaults-v21.1.3-1.21.1-NeoForge.jar" && \
    curl -sSL -o "mods/connectiblechains-neoforge-1.21.1-1.2.5.jar" \
        "https://cdn.modrinth.com/data/5pzBXDS3/versions/haHsKT7H/connectiblechains-neoforge-1.21.1-1.2.5.jar" && \
    curl -sSL -o "mods/connector-2.0.0-beta.14+1.21.1-full.jar" \
        "https://cdn.modrinth.com/data/u58R1TMW/versions/1i8teo7m/connector-2.0.0-beta.14%2B1.21.1-full.jar" && \
    curl -sSL -o "mods/ConnectorExtras-1.12.1+1.21.1.jar" \
        "https://cdn.modrinth.com/data/FYpiwiBR/versions/dgLCqZyo/ConnectorExtras-1.12.1%2B1.21.1.jar" && \
    curl -sSL -o "mods/coroutil-neoforge-1.21.0-1.3.8.jar" \
        "https://cdn.modrinth.com/data/rLLJ1OZM/versions/H2YXCYUY/coroutil-neoforge-1.21.0-1.3.8.jar" && \
    curl -sSL -o "mods/create_factory-0.5a-1.21.1.jar" \
        "https://cdn.modrinth.com/data/j6Zt3N7W/versions/7wShOUOC/create_factory-0.5a-1.21.1.jar" && \
    curl -sSL -o "mods/create_pattern_schematics-2.0.10.jar" \
        "https://cdn.modrinth.com/data/cpqKG67r/versions/VSJhIkG2/create_pattern_schematics-2.0.10.jar" && \
    curl -sSL -o "mods/create-1.21.1-6.0.10.jar" \
        "https://cdn.modrinth.com/data/LNytGWDc/versions/UjX6dr61/create-1.21.1-6.0.10.jar" && \
    curl -sSL -o "mods/create-aeronautics-bundled-1.21.1-1.1.3.jar" \
        "https://cdn.modrinth.com/data/oWaK0Q19/versions/1sv6OtSz/create-aeronautics-bundled-1.21.1-1.1.3.jar" && \
    curl -sSL -o "mods/create-cardboarded-conveynience-1.21.1-neoforge-1.0.0.jar" \
        "https://cdn.modrinth.com/data/dWU6xUnj/versions/DkktDPvc/create-cardboarded-conveynience-1.21.1-neoforge-1.0.0.jar" && \
    curl -sSL -o "mods/create-extended-wrenches-1.21.1-2.0.2.jar" \
        "https://cdn.modrinth.com/data/WNRCHiE5/versions/g0PyoRas/create-extended-wrenches-1.21.1-2.0.2.jar" && \
    curl -sSL -o "mods/create-shufflefilter-2.0.2-neo.jar" \
        "https://cdn.modrinth.com/data/gv5RRavC/versions/ifSwGuWK/create-shufflefilter-2.0.2-neo.jar" && \
    curl -sSL -o "mods/createframed-1.21.1-1.7.3.jar" \
        "https://cdn.modrinth.com/data/15fFZ3f4/versions/1BtGyIVR/createframed-1.21.1-1.7.3.jar" && \
    curl -sSL -o "mods/createprism-1.1.3.jar" \
        "https://cdn.modrinth.com/data/udEtt0b2/versions/py25OKuK/createprism-1.1.3.jar" && \
    curl -sSL -o "mods/distractingtrims-neoforge-1.21.1-21.1.1.jar" \
        "https://cdn.modrinth.com/data/xQU6E1ee/versions/2KEQq349/distractingtrims-neoforge-1.21.1-21.1.1.jar" && \
    curl -sSL -o "mods/e4mc-neoforge-6.1.0.jar" \
        "https://cdn.modrinth.com/data/qANg5Jrr/versions/rXxApWSO/e4mc-neoforge-6.1.0.jar" && \
    curl -sSL -o "mods/EasyAnvils-v21.1.0-1.21.1-NeoForge.jar" \
        "https://cdn.modrinth.com/data/OZBR5JT5/versions/fSQSKhdF/EasyAnvils-v21.1.0-1.21.1-NeoForge.jar" && \
    curl -sSL -o "mods/emi_loot-0.7.9+1.21+neoforge.jar" \
        "https://cdn.modrinth.com/data/qbbO7Jns/versions/QXkODMCT/emi_loot-0.7.9%2B1.21%2Bneoforge.jar" && \
    curl -sSL -o "mods/emi-1.1.22+1.21.1+neoforge.jar" \
        "https://cdn.modrinth.com/data/fRiHVvU7/versions/ouSj7NfF/emi-1.1.22%2B1.21.1%2Bneoforge.jar" && \
    curl -sSL -o "mods/endrem-neoforge-1.21.X-6.0.2.jar" \
        "https://cdn.modrinth.com/data/ZJTGwAND/versions/aqYxfNAS/endrem-neoforge-1.21.X-6.0.2.jar" && \
    curl -sSL -o "mods/ends_delight-2.5.1+neoforge.1.21.1.jar" \
        "https://cdn.modrinth.com/data/yHN0njMr/versions/YxSK1qNm/ends_delight-2.5.1%2Bneoforge.1.21.1.jar" && \
    curl -sSL -o "mods/FarmersDelight-1.21.1-1.2.11a.jar" \
        "https://cdn.modrinth.com/data/R2OftAxM/versions/rOESN0jP/FarmersDelight-1.21.1-1.2.11a.jar" && \
    curl -sSL -o "mods/fastpaintings-1.21-1.3.0-neoforge.jar" \
        "https://cdn.modrinth.com/data/z3TzcquW/versions/PQ155hbf/fastpaintings-1.21-1.3.0-neoforge.jar" && \
    curl -sSL -o "mods/ferritecore-7.0.3-neoforge.jar" \
        "https://cdn.modrinth.com/data/uXXizFIs/versions/x7kQWVju/ferritecore-7.0.3-neoforge.jar" && \
    curl -sSL -o "mods/forgified-fabric-api-0.116.7+2.2.4+1.21.1.jar" \
        "https://cdn.modrinth.com/data/Aqlf1Shp/versions/7nHK7hMg/forgified-fabric-api-0.116.7%2B2.2.4%2B1.21.1.jar" && \
    curl -sSL -o "mods/fzzy_config-0.7.6+1.21+neoforge.jar" \
        "https://cdn.modrinth.com/data/hYykXjDp/versions/MAPG6cXE/fzzy_config-0.7.6%2B1.21%2Bneoforge.jar" && \
    curl -sSL -o "mods/gml-6.0.2.jar" \
        "https://cdn.modrinth.com/data/zg2tT2Vu/versions/IDRMIIb4/gml-6.0.2.jar" && \
    curl -sSL -o "mods/iChunUtil-1.21-NeoForge-1.0.3.jar" \
        "https://cdn.modrinth.com/data/W6ROj0Hl/versions/OvIyyNh4/iChunUtil-1.21-NeoForge-1.0.3.jar" && \
    curl -sSL -o "mods/Kiwi-1.21.1-NeoForge-15.8.3.jar" \
        "https://cdn.modrinth.com/data/ufdDoWPd/versions/2flHQIzv/Kiwi-1.21.1-NeoForge-15.8.3.jar" && \
    curl -sSL -o "mods/konkrete_neoforge_1.9.9_MC_1.21.jar" \
        "https://cdn.modrinth.com/data/J81TRJWm/versions/stJDU839/konkrete_neoforge_1.9.9_MC_1.21.jar" && \
    curl -sSL -o "mods/kotlinforforge-5.11.0-all.jar" \
        "https://cdn.modrinth.com/data/ordsPcFz/versions/NrSebcsG/kotlinforforge-5.11.0-all.jar" && \
    curl -sSL -o "mods/lithium-neoforge-0.15.3+mc1.21.1.jar" \
        "https://cdn.modrinth.com/data/gvQqBUqZ/versions/RXHf27Wv/lithium-neoforge-0.15.3%2Bmc1.21.1.jar" && \
    curl -sSL -o "mods/lodestone-1.21.1-1.8.2.jar" \
        "https://cdn.modrinth.com/data/bN3xUWdo/versions/CohX6yP1/lodestone-1.21.1-1.8.2.jar" && \
    curl -sSL -o "mods/lootr-neoforge-1.21.1-1.11.37.118.jar" \
        "https://cdn.modrinth.com/data/EltpO5cN/versions/EB2B27qh/lootr-neoforge-1.21.1-1.11.37.118.jar" && \
    curl -sSL -o "mods/map_atlases-1.21-6.5.3-neoforge.jar" \
        "https://cdn.modrinth.com/data/4hwXMFif/versions/BlD4MEYm/map_atlases-1.21-6.5.3-neoforge.jar" && \
    curl -sSL -o "mods/minersdelight-1.21.1-1.4.2.jar" \
        "https://cdn.modrinth.com/data/qMxbM4BQ/versions/owA45PkH/minersdelight-1.21.1-1.4.2.jar" && \
    curl -sSL -o "mods/modernfix-neoforge-5.27.3+mc1.21.1.jar" \
        "https://cdn.modrinth.com/data/nmDcB62a/versions/QbebWhuK/modernfix-neoforge-5.27.3%2Bmc1.21.1.jar" && \
    curl -sSL -o "mods/moonlight-1.21-2.29.33-neoforge.jar" \
        "https://cdn.modrinth.com/data/twkfQtEc/versions/RftyTwKR/moonlight-1.21-2.29.33-neoforge.jar" && \
    curl -sSL -o "mods/more_sounds-1.21.x-0.3.0-beta.jar" \
        "https://cdn.modrinth.com/data/8jvcOd6S/versions/s0FVNDXY/more_sounds-1.21.x-0.3.0-beta.jar" && \
    curl -sSL -o "mods/mru-1.0.19+LTS+1.21.1+neoforge.jar" \
        "https://cdn.modrinth.com/data/SNVQ2c0g/versions/qYqVf5jP/mru-1.0.19%2BLTS%2B1.21.1%2Bneoforge.jar" && \
    curl -sSL -o "mods/MyNethersDelight-1.21.1-1.9.jar" \
        "https://cdn.modrinth.com/data/O53VhQoZ/versions/n2vJCdff/MyNethersDelight-1.21.1-1.9.jar" && \
    curl -sSL -o "mods/neobeefix-1.21.1-2.0.0.jar" \
        "https://cdn.modrinth.com/data/DzSY371i/versions/RFt9dm5Q/neobeefix-1.21.1-2.0.0.jar" && \
    curl -sSL -o "mods/netherite_horse_armor-neoforge-1.21.1-2.0a.jar" \
        "https://cdn.modrinth.com/data/nDFVOeq7/versions/PJ7q3Y9v/netherite_horse_armor-neoforge-1.21.1-2.0a.jar" && \
    curl -sSL -o "mods/netherportalfix-neoforge-1.21.1-21.1.1.jar" \
        "https://cdn.modrinth.com/data/nPZr02ET/versions/O09BGtgh/netherportalfix-neoforge-1.21.1-21.1.1.jar" && \
    curl -sSL -o "mods/noisium-neoforge-2.7.0+mc1.21-1.21.1.jar" \
        "https://cdn.modrinth.com/data/hasdd01q/versions/VviuomrA/noisium-neoforge-2.7.0%2Bmc1.21-1.21.1.jar" && \
    curl -sSL -o "mods/Not Enough Recipe Book-NEOFORGE-0.4.3+1.21.jar" \
        "https://cdn.modrinth.com/data/bQh7xzFq/versions/8SBaRv1t/Not%20Enough%20Recipe%20Book-NEOFORGE-0.4.3%2B1.21.jar" && \
    curl -sSL -o "mods/OctoLib-NEOFORGE-0.6.1+1.21.jar" \
        "https://cdn.modrinth.com/data/RH2KUdKJ/versions/AbiyvpxR/OctoLib-NEOFORGE-0.6.1%2B1.21.jar" && \
    curl -sSL -o "mods/potionstacks-1.0.0.jar" \
        "https://cdn.modrinth.com/data/CQTUbhIo/versions/bnlB3gWi/potionstacks-1.0.0.jar" && \
    curl -sSL -o "mods/prickle-neoforge-1.21.1-21.1.11.jar" \
        "https://cdn.modrinth.com/data/aaRl8GiW/versions/EE1FHDyD/prickle-neoforge-1.21.1-21.1.11.jar" && \
    curl -sSL -o "mods/PuzzlesLib-v21.1.39-1.21.1-NeoForge.jar" \
        "https://cdn.modrinth.com/data/QAGBst4M/versions/EgWWSAhJ/PuzzlesLib-v21.1.39-1.21.1-NeoForge.jar" && \
    curl -sSL -o "mods/Quark-4.1-477.jar" \
        "https://cdn.modrinth.com/data/qnQsVE2z/versions/qcDWHGnS/Quark-4.1-477.jar" && \
    curl -sSL -o "mods/quick-pack-neoforge-1.3.2+1.21.8.jar" \
        "https://cdn.modrinth.com/data/pSISfJ4O/versions/A5J7bhL4/quick-pack-neoforge-1.3.2%2B1.21.8.jar" && \
    curl -sSL -o "mods/railways-0.2.0-beta.2+neoforge-mc1.21.1.jar" \
        "https://cdn.modrinth.com/data/L3Jv0QZI/versions/dZa50kut/railways-0.2.0-beta.2%2Bneoforge-mc1.21.1.jar" && \
    curl -sSL -o "mods/resourcefulconfig-neoforge-1.21-3.0.11.jar" \
        "https://cdn.modrinth.com/data/M1953qlQ/versions/lSbyRD6v/resourcefulconfig-neoforge-1.21-3.0.11.jar" && \
    curl -sSL -o "mods/ritchiesprojectilelib-2.1.2+mc.1.21.1-neoforge.jar" \
        "https://cdn.modrinth.com/data/B3pb093D/versions/hZ6B2Z0x/ritchiesprojectilelib-2.1.2%2Bmc.1.21.1-neoforge.jar" && \
    curl -sSL -o "mods/sable-neoforge-1.21.1-1.1.3.jar" \
        "https://cdn.modrinth.com/data/T9PomCSv/versions/g8CObHcP/sable-neoforge-1.21.1-1.1.3.jar" && \
    curl -sSL -o "mods/scholar-neoforge-1.21.1-1.1.13.jar" \
        "https://cdn.modrinth.com/data/fX4dIQCo/versions/t5aJhKGV/scholar-neoforge-1.21.1-1.1.13.jar" && \
    curl -sSL -o "mods/seamlesssleep-neoforge-1.21-2.5.3.jar" \
        "https://cdn.modrinth.com/data/IyHq05yB/versions/Lw02ZJke/seamlesssleep-neoforge-1.21-2.5.3.jar" && \
    curl -sSL -o "mods/sliceanddice-forge-4.2.4.jar" \
        "https://cdn.modrinth.com/data/GmjmRQ0A/versions/tyVnEa75/sliceanddice-forge-4.2.4.jar" && \
    curl -sSL -o "mods/smarterfarmers-1.21-2.2.4-neoforge.jar" \
        "https://cdn.modrinth.com/data/Bh6ZOMvp/versions/odppGdXf/smarterfarmers-1.21-2.2.4-neoforge.jar" && \
    curl -sSL -o "mods/sophisticatedbackpacks-1.21.1-3.25.41.1683.jar" \
        "https://cdn.modrinth.com/data/TyCTlI4b/versions/TiDxy94j/sophisticatedbackpacks-1.21.1-3.25.41.1683.jar" && \
    curl -sSL -o "mods/sophisticatedcore-1.21.1-1.4.29.1752.jar" \
        "https://cdn.modrinth.com/data/nmoqTijg/versions/M4Xj4ig7/sophisticatedcore-1.21.1-1.4.29.1752.jar" && \
    curl -sSL -o "mods/structure_layout_optimizer-neoforge-1.0.12.jar" \
        "https://cdn.modrinth.com/data/ayPU0OHc/versions/eTz03Gfd/structure_layout_optimizer-neoforge-1.0.12.jar" && \
    curl -sSL -o "mods/supplementaries-1.21-3.5.34-neoforge.jar" \
        "https://cdn.modrinth.com/data/fFEIiSDQ/versions/NuQNqCLy/supplementaries-1.21-3.5.34-neoforge.jar" && \
    curl -sSL -o "mods/trashslot-neoforge-1.21.1-21.1.4.jar" \
        "https://cdn.modrinth.com/data/vRYk0bv7/versions/xyqrX19y/trashslot-neoforge-1.21.1-21.1.4.jar" && \
    curl -sSL -o "mods/txnilib-neoforge-1.0.24-1.21.1.jar" \
        "https://cdn.modrinth.com/data/vBbPDuOs/versions/M1CyD3Uu/txnilib-neoforge-1.0.24-1.21.1.jar" && \
    curl -sSL -o "mods/Updating World Icon-neoforge-1.21.1-1.0.1.jar" \
        "https://cdn.modrinth.com/data/ZlX3EVmE/versions/qEFip2XZ/Updating%20World%20Icon-neoforge-1.21.1-1.0.1.jar" && \
    curl -sSL -o "mods/voicechat-neoforge-1.21.1-2.6.16.jar" \
        "https://cdn.modrinth.com/data/9eGKb6K1/versions/rGX4hrtP/voicechat-neoforge-1.21.1-2.6.16.jar" && \
    curl -sSL -o "mods/yet_another_config_lib_v3-3.8.2+1.21.1-neoforge.jar" \
        "https://cdn.modrinth.com/data/1eAoo2KR/versions/7TVdVtxF/yet_another_config_lib_v3-3.8.2%2B1.21.1-neoforge.jar" && \
    curl -sSL -o "mods/YungsApi-1.21.1-NeoForge-5.1.6.jar" \
        "https://cdn.modrinth.com/data/Ua7DFN59/versions/ZB22DE9q/YungsApi-1.21.1-NeoForge-5.1.6.jar" && \
    curl -sSL -o "mods/YungsBetterDesertTemples-1.21.1-NeoForge-4.1.5.jar" \
        "https://cdn.modrinth.com/data/XNlO7sBv/versions/GQ9iNWkI/YungsBetterDesertTemples-1.21.1-NeoForge-4.1.5.jar" && \
    curl -sSL -o "mods/YungsBetterDungeons-1.21.1-NeoForge-5.1.4.jar" \
        "https://cdn.modrinth.com/data/o1C1Dkj5/versions/D6aZn0Em/YungsBetterDungeons-1.21.1-NeoForge-5.1.4.jar" && \
    curl -sSL -o "mods/YungsBetterNetherFortresses-1.21.1-NeoForge-3.1.5.jar" \
        "https://cdn.modrinth.com/data/Z2mXHnxP/versions/iopJiJQp/YungsBetterNetherFortresses-1.21.1-NeoForge-3.1.5.jar" && \
    curl -sSL -o "mods/YungsBetterOceanMonuments-1.21.1-NeoForge-4.1.2.jar" \
        "https://cdn.modrinth.com/data/3dT9sgt4/versions/yFjEcj2g/YungsBetterOceanMonuments-1.21.1-NeoForge-4.1.2.jar" && \
    curl -sSL -o "mods/YungsBetterStrongholds-1.21.1-NeoForge-5.1.3.jar" \
        "https://cdn.modrinth.com/data/kidLKymU/versions/8U0dIfSM/YungsBetterStrongholds-1.21.1-NeoForge-5.1.3.jar" && \
    curl -sSL -o "mods/YungsExtras-1.21.1-NeoForge-5.1.1.jar" \
        "https://cdn.modrinth.com/data/ZYgyPyfq/versions/N2EpMhR7/YungsExtras-1.21.1-NeoForge-5.1.1.jar" && \
    curl -sSL -o "mods/Zeta-1.1-40.jar" \
        "https://cdn.modrinth.com/data/MVARlG2f/versions/9GjNW2Gf/Zeta-1.1-40.jar"

# =============================================================================
# Runtime stage
# =============================================================================
FROM eclipse-temurin:21-jre

WORKDIR /server

# Copy NeoForge server files
COPY --from=builder /build/libraries /server/libraries
COPY --from=builder /build/mods /server/mods

# Copy server config
COPY server.properties /server/server.properties
COPY start.sh /server/start.sh
RUN chmod +x /server/start.sh

# Accept EULA
RUN echo "eula=true" > /server/eula.txt

# Expose ports
# 25565/TCP - Minecraft
# 24454/UDP - Simple Voice Chat
EXPOSE 25565/tcp
EXPOSE 24454/udp

# Volumes for persistent data
VOLUME ["/server/world", "/server/config"]

# Environment variables for memory tuning
ENV MAX_MEMORY=4G
ENV MIN_MEMORY=2G

# Health check
HEALTHCHECK --interval=60s --timeout=10s --start-period=180s --retries=3 \
    CMD echo "list" | nc -w 3 localhost 25565 || exit 1

ENTRYPOINT ["/server/start.sh"]
