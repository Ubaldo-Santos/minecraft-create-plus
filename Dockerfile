# =============================================================================
# Minecraft Create+ Server - Custom Build
# MC 1.19.2 | Forge 43.5.1 | Create+ 5.2.1b (Server Pack)
# =============================================================================
# Compatible with Dokploy deployment
# =============================================================================

FROM eclipse-temurin:17-jre AS builder

WORKDIR /build

ARG MC_VERSION=1.19.2
ARG FORGE_VERSION=43.5.1

RUN apt-get update && apt-get install -y --no-install-recommends curl unzip && rm -rf /var/lib/apt/lists/*

# Install Forge server
RUN curl -sSL -o forge-installer.jar \
    "https://maven.minecraftforge.net/net/minecraftforge/forge/${MC_VERSION}-${FORGE_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar" && \
    java -jar forge-installer.jar --installServer && \
    rm forge-installer.jar forge-installer.jar.log 2>/dev/null || true

# Download mrpack and extract override mods (CurseForge-only JARs including citadel)
RUN curl -sSL -o server.mrpack \
    "https://cdn.modrinth.com/data/t1tOiUHZ/versions/OirSzesD/Create%2B%205.2.1b%20%28Server%20Pack%29.mrpack" && \
    mkdir -p mods mrpack_tmp && \
    unzip -q server.mrpack "overrides/mods/*" -d mrpack_tmp/ && \
    cp mrpack_tmp/overrides/mods/*.jar mods/ && \
    rm -rf mrpack_tmp server.mrpack && \
    echo "Extracted $(ls mods/*.jar | wc -l) override mods"

# Download server-compatible mods from Modrinth (208 mods from server pack index)
RUN \
    curl -sSL -o "mods/BlockRunner-v4.2.2-1.19.2-Forge.jar" \
        "https://cdn.modrinth.com/data/1VSGxqkt/versions/MxlSUiGV/BlockRunner-v4.2.2-1.19.2-Forge.jar" && \
    curl -sSL -o "mods/corn_delight-1.0.3-1.19.2.jar" \
        "https://cdn.modrinth.com/data/uxLAKWU8/versions/yOYdkPX6/corn_delight-1.0.3-1.19.2.jar" && \
    curl -sSL -o "mods/farmers-cutting-quark-1.0.0-1.19.jar" \
        "https://cdn.modrinth.com/data/rH2QzhPh/versions/pPKj4Q5L/farmers-cutting-quark-1.0.0-1.19.jar" && \
    curl -sSL -o "mods/ArmorStatues-v4.0.8-1.19.2-Forge.jar" \
        "https://cdn.modrinth.com/data/bbGCtEvb/versions/ASuYpCVK/ArmorStatues-v4.0.8-1.19.2-Forge.jar" && \
    curl -sSL -o "mods/EasyAnvils-v4.0.11-1.19.2-Forge.jar" \
        "https://cdn.modrinth.com/data/OZBR5JT5/versions/iYAQ1oaP/EasyAnvils-v4.0.11-1.19.2-Forge.jar" && \
    curl -sSL -o "mods/TerraBlender-forge-1.19.2-2.0.1.166.jar" \
        "https://cdn.modrinth.com/data/kkmrDlKT/versions/qpCqqA93/TerraBlender-forge-1.19.2-2.0.1.166.jar" && \
    curl -sSL -o "mods/rechiseled-1.1.6-forge-mc1.19.2.jar" \
        "https://cdn.modrinth.com/data/B0g2vT6l/versions/MqJJHr9Y/rechiseled-1.1.6-forge-mc1.19.2.jar" && \
    curl -sSL -o "mods/yeetusexperimentus-1.0.1-build.2+mc1.19.1.jar" \
        "https://cdn.modrinth.com/data/HaaH232J/versions/YnVV0O6w/yeetusexperimentus-1.0.1-build.2%2Bmc1.19.1.jar" && \
    curl -sSL -o "mods/interiors-0.5.6+forge-mc1.19.2-build.105.jar" \
        "https://cdn.modrinth.com/data/r4Knci2k/versions/BRGHEQfA/interiors-0.5.6%2Bforge-mc1.19.2-build.105.jar" && \
    curl -sSL -o "mods/AdditionalBanners-Forge-1.19.2-10.1.7.jar" \
        "https://cdn.modrinth.com/data/AVPTFuxC/versions/UH1I51wt/AdditionalBanners-Forge-1.19.2-10.1.7.jar" && \
    curl -sSL -o "mods/customizableelytra-1.19.0-1.7.4.jar" \
        "https://cdn.modrinth.com/data/L25fOeGq/versions/gsnrKi46/customizableelytra-1.19.0-1.7.4.jar" && \
    curl -sSL -o "mods/infusion_table-1.2.0.jar" \
        "https://cdn.modrinth.com/data/W9CiRGYK/versions/T9vNtB4D/infusion_table-1.2.0.jar" && \
    curl -sSL -o "mods/advancementframes-1.19.2-2.0.0.jar" \
        "https://cdn.modrinth.com/data/zUBn5hHr/versions/OmkOgujn/advancementframes-1.19.2-2.0.0.jar" && \
    curl -sSL -o "mods/waveycapes-forge-1.6.2-mc1.19.2.jar" \
        "https://cdn.modrinth.com/data/kYuIpRLv/versions/s36Aaovz/waveycapes-forge-1.6.2-mc1.19.2.jar" && \
    curl -sSL -o "mods/structure_layout_optimizer-forge-1.0.10.jar" \
        "https://cdn.modrinth.com/data/ayPU0OHc/versions/wpAWKJ20/structure_layout_optimizer-forge-1.0.10.jar" && \
    curl -sSL -o "mods/blueprint-1.19.2-6.2.0.jar" \
        "https://cdn.modrinth.com/data/VsM5EDoI/versions/SnLXbWe9/blueprint-1.19.2-6.2.0.jar" && \
    curl -sSL -o "mods/SizeShiftingPotions-forge-1.19.2-1.5.1.jar" \
        "https://cdn.modrinth.com/data/rfj2v0X6/versions/JSvYKZCe/SizeShiftingPotions-forge-1.19.2-1.5.1.jar" && \
    curl -sSL -o "mods/voicechat-forge-1.19.2-2.5.36.jar" \
        "https://cdn.modrinth.com/data/9eGKb6K1/versions/c2pRRWUm/voicechat-forge-1.19.2-2.5.36.jar" && \
    curl -sSL -o "mods/YungsBridges-1.19.2-Forge-3.1.0.jar" \
        "https://cdn.modrinth.com/data/Ht4BfYp6/versions/rgVgefNE/YungsBridges-1.19.2-Forge-3.1.0.jar" && \
    curl -sSL -o "mods/Icterine-forge-1.2.0.jar" \
        "https://cdn.modrinth.com/data/7RvRWn6p/versions/tMsh5MyG/Icterine-forge-1.2.0.jar" && \
    curl -sSL -o "mods/Xaeros_Minimap_25.2.6_Forge_1.19.1.jar" \
        "https://cdn.modrinth.com/data/1bokaNcj/versions/rCBwdCZO/Xaeros_Minimap_25.2.6_Forge_1.19.1.jar" && \
    curl -sSL -o "mods/aquatictorches-1.19-1.1.0.jar" \
        "https://cdn.modrinth.com/data/yJR377od/versions/HZ6zHTth/aquatictorches-1.19-1.1.0.jar" && \
    curl -sSL -o "mods/netherportalfix-forge-1.19-10.0.2.jar" \
        "https://cdn.modrinth.com/data/nPZr02ET/versions/WJBCsJlq/netherportalfix-forge-1.19-10.0.2.jar" && \
    curl -sSL -o "mods/ferritecore-5.0.3-forge.jar" \
        "https://cdn.modrinth.com/data/uXXizFIs/versions/CtXsUUz6/ferritecore-5.0.3-forge.jar" && \
    curl -sSL -o "mods/Fastload-Reforged-mc1.19.2-3.4.0.jar" \
        "https://cdn.modrinth.com/data/kCpssoSb/versions/nHeyxX0A/Fastload-Reforged-mc1.19.2-3.4.0.jar" && \
    curl -sSL -o "mods/DeathKnell-Forge-1.19.2-6.0.3.jar" \
        "https://cdn.modrinth.com/data/WNdd2blX/versions/KCMrvAXI/DeathKnell-Forge-1.19.2-6.0.3.jar" && \
    curl -sSL -o "mods/endergetic-1.19.2-4.0.0.jar" \
        "https://cdn.modrinth.com/data/cPle5Z8G/versions/VDTdGjUK/endergetic-1.19.2-4.0.0.jar" && \
    curl -sSL -o "mods/fluidlogged-1.2.0-forge-mc1.19.jar" \
        "https://cdn.modrinth.com/data/BnXpPaut/versions/yrd5wZhl/fluidlogged-1.2.0-forge-mc1.19.jar" && \
    curl -sSL -o "mods/paintable-1.0d-1.19.2.jar" \
        "https://cdn.modrinth.com/data/pNalfbjI/versions/8WvRrClF/paintable-1.0d-1.19.2.jar" && \
    curl -sSL -o "mods/sit-1.19-1.3.3.jar" \
        "https://cdn.modrinth.com/data/VKXzIykF/versions/T1eFly6W/sit-1.19.2-1.3.3.jar" && \
    curl -sSL -o "mods/horsestonks-forge-1.17+-1.0.1.jar" \
        "https://cdn.modrinth.com/data/Vj70oKlA/versions/1.0.1-Forge1.17%2B/horsestonks-forge-1.17%2B-1.0.1.jar" && \
    curl -sSL -o "mods/forgeshot-1.0.jar" \
        "https://cdn.modrinth.com/data/3j0bB3uL/versions/4mHtKPuw/forgeshot-1.0.jar" && \
    curl -sSL -o "mods/noisium-1.0.2.jar" \
        "https://cdn.modrinth.com/data/JRYQR8rr/versions/f16ggOyj/noisium-1.0.2.jar" && \
    curl -sSL -o "mods/Delightful-1.19.2-3.4.1.jar" \
        "https://cdn.modrinth.com/data/JtSnhtNJ/versions/3kuWUhts/Delightful-1.19.2-3.4.1.jar" && \
    curl -sSL -o "mods/NoChatReports-FORGE-1.19.2-v1.5.1.jar" \
        "https://cdn.modrinth.com/data/qQyHxfxd/versions/RNAG69Zu/NoChatReports-FORGE-1.19.2-v1.5.1.jar" && \
    curl -sSL -o "mods/mutil-1.19.2-5.2.0.jar" \
        "https://cdn.modrinth.com/data/HWHl8Evb/versions/1cVegazl/mutil-1.19.2-5.2.0.jar" && \
    curl -sSL -o "mods/create-confectionery1.19.2_v1.0.9.jar" \
        "https://cdn.modrinth.com/data/WPE5gRs9/versions/rLTtWIfx/create-confectionery1.19.2_v1.0.9.jar" && \
    curl -sSL -o "mods/JadeAddons-1.19.2-forge-3.6.0.jar" \
        "https://cdn.modrinth.com/data/xuDOzCLy/versions/rPlsZgp0/JadeAddons-1.19.2-forge-3.6.0.jar" && \
    curl -sSL -o "mods/watut-forge-1.19.2-1.0.14.jar" \
        "https://cdn.modrinth.com/data/AtB5mHky/versions/L63H84ys/watut-forge-1.19.2-1.0.14.jar" && \
    curl -sSL -o "mods/Jade-1.19.1-forge-8.9.2.jar" \
        "https://cdn.modrinth.com/data/nvQzSEkH/versions/kp0HjPre/Jade-1.19.1-forge-8.9.2.jar" && \
    curl -sSL -o "mods/saturn-mc1.19.2-0.1.4.jar" \
        "https://cdn.modrinth.com/data/2eT495vq/versions/np1EcSVx/saturn-mc1.19.2-0.1.4.jar" && \
    curl -sSL -o "mods/appleskin-forge-mc1.19-2.4.2.jar" \
        "https://cdn.modrinth.com/data/EsAfCjCV/versions/forge-mc1.19-2.4.2/appleskin-forge-mc1.19-2.4.2.jar" && \
    curl -sSL -o "mods/sliceanddice-forge-2.4.0.jar" \
        "https://cdn.modrinth.com/data/GmjmRQ0A/versions/2YFOoeUh/sliceanddice-forge-2.4.0.jar" && \
    curl -sSL -o "mods/domesticationinnovation-1.6.1-1.19.2.jar" \
        "https://cdn.modrinth.com/data/h5JyLdjM/versions/FQhDA1rS/domesticationinnovation-1.6.1-1.19.2.jar" && \
    curl -sSL -o "mods/createaddition-1.19.2-1.2.2.jar" \
        "https://cdn.modrinth.com/data/kU1G12Nn/versions/AjwN7Aq8/createaddition-1.19.2-1.2.2.jar" && \
    curl -sSL -o "mods/Statement-4.2.7+1.19.2-forge.jar" \
        "https://cdn.modrinth.com/data/a9AsUNGn/versions/fim7a2ol/Statement-4.2.7%2B1.19.2-forge.jar" && \
    curl -sSL -o "mods/supplementaries-1.19.2-2.4.20.jar" \
        "https://cdn.modrinth.com/data/fFEIiSDQ/versions/UQu29fD5/supplementaries-1.19.2-2.4.20.jar" && \
    curl -sSL -o "mods/balm-forge-1.19.2-4.6.0.jar" \
        "https://cdn.modrinth.com/data/MBAkmtvl/versions/d7a0S3hj/balm-forge-1.19.2-4.6.0.jar" && \
    curl -sSL -o "mods/Ender-Relay-1.19.2-Forge-1.1.0.jar" \
        "https://cdn.modrinth.com/data/X0uEaA4Z/versions/2OgHaTNI/Ender-Relay-1.19.2-Forge-1.1.0.jar" && \
    curl -sSL -o "mods/alloyed-1.19.2-v1.5a.jar" \
        "https://cdn.modrinth.com/data/KUInlTFo/versions/SFWaKYwq/alloyed-1.19.2-v1.5a.jar" && \
    curl -sSL -o "mods/ServerTabInfo-1.19.1-1.3.7.jar" \
        "https://cdn.modrinth.com/data/VZptDEBF/versions/1.19.1-1.3.7/ServerTabInfo-1.19.1-1.3.7.jar" && \
    curl -sSL -o "mods/sophisticatedcore-1.19.2-0.6.4.730.jar" \
        "https://cdn.modrinth.com/data/nmoqTijg/versions/LRDUyYPU/sophisticatedcore-1.19.2-0.6.4.730.jar" && \
    curl -sSL -o "mods/AxesAreWeapons-1.7.3-forge-1.19.2.jar" \
        "https://cdn.modrinth.com/data/1jvt7RTc/versions/g6YtnyPC/AxesAreWeapons-1.7.3-forge-1.19.2.jar" && \
    curl -sSL -o "mods/Steam_Rails-1.6.6+forge-mc1.19.2.jar" \
        "https://cdn.modrinth.com/data/ZzjhlDgM/versions/AYmDx1OW/Steam_Rails-1.6.6%2Bforge-mc1.19.2.jar" && \
    curl -sSL -o "mods/create_power_loader-1.5.0-mc1.19.2.jar" \
        "https://cdn.modrinth.com/data/wPQ6GgFE/versions/GuYzoHQC/create_power_loader-1.5.0-mc1.19.2.jar" && \
    curl -sSL -o "mods/bellsandwhistles-v0.4.4-1.19.2.jar" \
        "https://cdn.modrinth.com/data/gJ5afkVv/versions/zgdMDJ9K/bellsandwhistles-v0.4.4-1.19.2.jar" && \
    curl -sSL -o "mods/untitledduckmod-0.6.1-1.19.2-forge.jar" \
        "https://cdn.modrinth.com/data/ojFjz7JF/versions/4C9cxXuI/untitledduckmod-0.6.1-1.19.2-forge.jar" && \
    curl -sSL -o "mods/polymorph-forge-0.46.6+1.19.2.jar" \
        "https://cdn.modrinth.com/data/tagwiZkJ/versions/6tFcWl5d/polymorph-forge-0.46.6%2B1.19.2.jar" && \
    curl -sSL -o "mods/skippy-pearls-1.4.jar" \
        "https://cdn.modrinth.com/data/KM7gMSY1/versions/uXDwLG3V/skippy-pearls-1.4.jar" && \
    curl -sSL -o "mods/BoatBreakFix-Universal-1.0.2.jar" \
        "https://cdn.modrinth.com/data/OVb8ZE5p/versions/Uf9jCC3m/BoatBreakFix-Universal-1.0.2.jar" && \
    curl -sSL -o "mods/supermartijn642configlib-1.1.8-forge-mc1.19.jar" \
        "https://cdn.modrinth.com/data/LN9BxssP/versions/HHm0Di8Y/supermartijn642configlib-1.1.8-forge-mc1.19.jar" && \
    curl -sSL -o "mods/YungsBetterDesertTemples-1.19.2-Forge-2.2.2.jar" \
        "https://cdn.modrinth.com/data/XNlO7sBv/versions/4szLNMTj/YungsBetterDesertTemples-1.19.2-Forge-2.2.2.jar" && \
    curl -sSL -o "mods/majrusz-library-forge-1.19.2-7.0.5-backport.1.jar" \
        "https://cdn.modrinth.com/data/PYQD8noM/versions/qnTJx9bI/majrusz-library-forge-1.19.2-7.0.5-backport.1.jar" && \
    curl -sSL -o "mods/findme-3.1.0-forge.jar" \
        "https://cdn.modrinth.com/data/rEuzehyH/versions/EUIz7jbt/findme-3.1.0-forge.jar" && \
    curl -sSL -o "mods/potionbundles-1.19.1-1.6.jar" \
        "https://cdn.modrinth.com/data/ZZLWU8jS/versions/CJ0dObLc/potionbundles-1.19.1-1.6.jar" && \
    curl -sSL -o "mods/create_crystal_clear-0.2.1-1.19.2.jar" \
        "https://cdn.modrinth.com/data/h7QgiH72/versions/YEuo20pc/create_crystal_clear-0.2.1-1.19.2.jar" && \
    curl -sSL -o "mods/voidtotem-forge-1.19.2-2.1.0.jar" \
        "https://cdn.modrinth.com/data/q6eiiQ07/versions/2r4TLyh6/voidtotem-forge-1.19.2-2.1.0.jar" && \
    curl -sSL -o "mods/hourglass-1.19.1-1.2.1.1.jar" \
        "https://cdn.modrinth.com/data/1ZqmoFFP/versions/ZMHn5FFd/hourglass-1.19.1-1.2.1.1.jar" && \
    curl -sSL -o "mods/architectury-6.6.92-forge.jar" \
        "https://cdn.modrinth.com/data/lhGA9TYQ/versions/96L7fC9l/architectury-6.6.92-forge.jar" && \
    curl -sSL -o "mods/do-a-barrel-roll-2.6.2+1.19.2-forge.jar" \
        "https://cdn.modrinth.com/data/6FtRfnLg/versions/nybnGUJv/do-a-barrel-roll-2.6.2%2B1.19.2-forge.jar" && \
    curl -sSL -o "mods/woodworks-1.19.2-2.2.2.jar" \
        "https://cdn.modrinth.com/data/rv1sovni/versions/prgM2znB/woodworks-1.19.2-2.2.2.jar" && \
    curl -sSL -o "mods/xercapaint-1.19.2-1.0.2.jar" \
        "https://cdn.modrinth.com/data/YOs4tZea/versions/OPV3tCmc/xercapaint-1.19.2-1.0.2.jar" && \
    curl -sSL -o "mods/create_jetpack-forge-3.4.2.jar" \
        "https://cdn.modrinth.com/data/UbFnAd4l/versions/wdap0JAj/create_jetpack-forge-3.4.2.jar" && \
    curl -sSL -o "mods/nerb-1.19.2-0.3-FORGE.jar" \
        "https://cdn.modrinth.com/data/bQh7xzFq/versions/ANmCMdMt/nerb-1.19.2-0.3-FORGE.jar" && \
    curl -sSL -o "mods/XaerosWorldMap_1.39.12_Forge_1.19.1.jar" \
        "https://cdn.modrinth.com/data/NcUtCpym/versions/v0vH7Baf/XaerosWorldMap_1.39.12_Forge_1.19.1.jar" && \
    curl -sSL -o "mods/YungsBetterDungeons-1.19.2-Forge-3.2.2.jar" \
        "https://cdn.modrinth.com/data/o1C1Dkj5/versions/vhbhPrpZ/YungsBetterDungeons-1.19.2-Forge-3.2.2.jar" && \
    curl -sSL -o "mods/AutoRegLib-1.8.2-55.jar" \
        "https://cdn.modrinth.com/data/NvZ9ZhwE/versions/pwEa2yJ2/AutoRegLib-1.8.2-55.jar" && \
    curl -sSL -o "mods/snowballsfreezemobs-1.19.2-3.3.jar" \
        "https://cdn.modrinth.com/data/ETKe9DNz/versions/LebEybAw/snowballsfreezemobs-1.19.2-3.3.jar" && \
    curl -sSL -o "mods/extendedbonemeal-1.19.2-3.4.jar" \
        "https://cdn.modrinth.com/data/bHkCoxMs/versions/z4bZjSsw/extendedbonemeal-1.19.2-3.4.jar" && \
    curl -sSL -o "mods/despawningeggshatch-1.19.2-4.3.jar" \
        "https://cdn.modrinth.com/data/iKRtwScn/versions/OxJ3LkHD/despawningeggshatch-1.19.2-4.3.jar" && \
    curl -sSL -o "mods/MagnumTorch-v4.2.3-1.19.2-Forge.jar" \
        "https://cdn.modrinth.com/data/jorDmSKv/versions/ZVPHXuR1/MagnumTorch-v4.2.3-1.19.2-Forge.jar" && \
    curl -sSL -o "mods/capes-1.5.2+1.19.2-forge.jar" \
        "https://cdn.modrinth.com/data/89Wsn8GD/versions/WgQhPB7O/capes-1.5.2%2B1.19.2-forge.jar" && \
    curl -sSL -o "mods/caelus-forge-1.19.2-3.0.0.6.jar" \
        "https://cdn.modrinth.com/data/40FYwb4z/versions/hmlQQjAc/caelus-forge-1.19.2-3.0.0.6.jar" && \
    curl -sSL -o "mods/clayworks-1.19.2-2.1.0.jar" \
        "https://cdn.modrinth.com/data/1iicrEO3/versions/Skc3zBzk/clayworks-1.19.2-2.1.0.jar" && \
    curl -sSL -o "mods/grindstonesharpertools-1.19.2-3.5.jar" \
        "https://cdn.modrinth.com/data/p6y1z1Qa/versions/z8KfF07r/grindstonesharpertools-1.19.2-3.5.jar" && \
    curl -sSL -o "mods/YungsBetterStrongholds-1.19.2-Forge-3.2.0.jar" \
        "https://cdn.modrinth.com/data/kidLKymU/versions/aW1VWzje/YungsBetterStrongholds-1.19.2-Forge-3.2.0.jar" && \
    curl -sSL -o "mods/torch-hit-forge-1.19.2-7.0.0.jar" \
        "https://cdn.modrinth.com/data/zTOq9jEI/versions/jxnpwWtW/torch-hit-forge-1.19.2-7.0.0.jar" && \
    curl -sSL -o "mods/scaffoldingdropsnearby-1.19.2-3.2.jar" \
        "https://cdn.modrinth.com/data/uO522mgw/versions/wmgHQrOJ/scaffoldingdropsnearby-1.19.2-3.2.jar" && \
    curl -sSL -o "mods/justplayerheads-1.19.2-4.0.jar" \
        "https://cdn.modrinth.com/data/YdVBZMNR/versions/cA7V7gzZ/justplayerheads-1.19.2-4.0.jar" && \
    curl -sSL -o "mods/YungsBetterJungleTemples-1.19.2-Forge-1.0.1.jar" \
        "https://cdn.modrinth.com/data/z9Ve58Ih/versions/REe7auh2/YungsBetterJungleTemples-1.19.2-Forge-1.0.1.jar" && \
    curl -sSL -o "mods/Item-Obliterator-Forge-1.19.2-2.2.1.jar" \
        "https://cdn.modrinth.com/data/3ESR84kR/versions/7wB98NiB/Item-Obliterator-Forge-1.19.2-2.2.1.jar" && \
    curl -sSL -o "mods/enderpearlswap-1.19.2-1.0.1.jar" \
        "https://cdn.modrinth.com/data/RCVgMVGI/versions/aqCItsah/enderpearlswap-1.19.2-1.0.1.jar" && \
    curl -sSL -o "mods/chalk-1.19.2-1.6.3.jar" \
        "https://cdn.modrinth.com/data/YWGP4Y1d/versions/fvS0q7eV/chalk-1.19.2-1.6.3.jar" && \
    curl -sSL -o "mods/keepmysoiltilled-1.19.2-2.2.jar" \
        "https://cdn.modrinth.com/data/OC5Zubbe/versions/CiuqKbEu/keepmysoiltilled-1.19.2-2.2.jar" && \
    curl -sSL -o "mods/pattern_schematics-1.1.15+forge-1.19.2.jar" \
        "https://cdn.modrinth.com/data/cpqKG67r/versions/8eNRNmfQ/pattern_schematics-1.1.15%2Bforge-1.19.2.jar" && \
    curl -sSL -o "mods/sophisticatedstorage-1.19.2-0.9.7.765.jar" \
        "https://cdn.modrinth.com/data/hMlaZH8f/versions/Aaxjk1hL/sophisticatedstorage-1.19.2-0.9.7.765.jar" && \
    curl -sSL -o "mods/fallingtrees-forge-mc1.19.2-0.13.2-SNAPSHOT.jar" \
        "https://cdn.modrinth.com/data/i2kUe4lq/versions/xch7dyzN/fallingtrees-forge-mc1.19.2-0.13.2-SNAPSHOT.jar" && \
    curl -sSL -o "mods/Iceberg-1.19.2-forge-1.1.4.jar" \
        "https://cdn.modrinth.com/data/5faXoLqX/versions/wog3r1ZM/Iceberg-1.19.2-forge-1.1.4.jar" && \
    curl -sSL -o "mods/Quark-3.4-418.jar" \
        "https://cdn.modrinth.com/data/qnQsVE2z/versions/8po5DGR8/Quark-3.4-418.jar" && \
    curl -sSL -o "mods/moonlight-1.19.2-2.3.7-forge.jar" \
        "https://cdn.modrinth.com/data/twkfQtEc/versions/4R7I44b3/moonlight-1.19.2-2.3.7-forge.jar" && \
    curl -sSL -o "mods/SnowRealMagic-1.19.2-forge-6.5.4.jar" \
        "https://cdn.modrinth.com/data/iJNje1E8/versions/BywGg9xj/SnowRealMagic-1.19.2-forge-6.5.4.jar" && \
    curl -sSL -o "mods/radiantgear-forge-2.0.4+1.19.2.jar" \
        "https://cdn.modrinth.com/data/AtT9wm5O/versions/wkRh0MZp/radiantgear-forge-2.0.4%2B1.19.2.jar" && \
    curl -sSL -o "mods/Projectiles-1.0.0-1.19.2-Multi.jar" \
        "https://cdn.modrinth.com/data/UblF21s1/versions/sgQBX0tV/Projectiles-1.0.0-1.19.2-Multi.jar" && \
    curl -sSL -o "mods/majruszs-enchantments-forge-1.19.2-1.10.7-backport.1.jar" \
        "https://cdn.modrinth.com/data/jJthQvHv/versions/bTxb1AAt/majruszs-enchantments-forge-1.19.2-1.10.7-backport.1.jar" && \
    curl -sSL -o "mods/iChunUtil-1.19.2-Forge-1.0.3.jar" \
        "https://cdn.modrinth.com/data/W6ROj0Hl/versions/jybCUL3J/iChunUtil-1.19.2-Forge-1.0.3.jar" && \
    curl -sSL -o "mods/alternate-current-mc1.19-1.7.0.jar" \
        "https://cdn.modrinth.com/data/r0v8vy1s/versions/v9lKbHW6/alternate-current-mc1.19-1.7.0.jar" && \
    curl -sSL -o "mods/modernfix-forge-5.18.1+mc1.19.2.jar" \
        "https://cdn.modrinth.com/data/nmDcB62a/versions/FqoRZlrr/modernfix-forge-5.18.1%2Bmc1.19.2.jar" && \
    curl -sSL -o "mods/create_factory-0.0.2-1.19.2.jar" \
        "https://cdn.modrinth.com/data/j6Zt3N7W/versions/OGnDlRJa/create_factory-0.0.2-1.19.2.jar" && \
    curl -sSL -o "mods/jei-1.19.2-forge-11.8.1.1034.jar" \
        "https://cdn.modrinth.com/data/u6dRKJwZ/versions/LIkb8oaL/jei-1.19.2-forge-11.8.1.1034.jar" && \
    curl -sSL -o "mods/friendsandfoes-forge-mc1.19.2-3.0.9.jar" \
        "https://cdn.modrinth.com/data/BOCJKD49/versions/Xw3rjCWU/friendsandfoes-forge-mc1.19.2-3.0.9.jar" && \
    curl -sSL -o "mods/ends_delight-1.19.2-2.1.jar" \
        "https://cdn.modrinth.com/data/yHN0njMr/versions/Q4q0rf2I/ends_delight-1.19.2-2.1.jar" && \
    curl -sSL -o "mods/konkrete_forge_1.8.0_MC_1.19-1.19.2.jar" \
        "https://cdn.modrinth.com/data/J81TRJWm/versions/QMv1le10/konkrete_forge_1.8.0_MC_1.19-1.19.2.jar" && \
    curl -sSL -o "mods/Companion-1.19.2-forge-3.1.3.jar" \
        "https://cdn.modrinth.com/data/4w0EzGRW/versions/7NBgz9Ej/Companion-1.19.2-forge-3.1.3.jar" && \
    curl -sSL -o "mods/abnormals_delight-1.19.2-4.1.2.jar" \
        "https://cdn.modrinth.com/data/ts3qjo5t/versions/u2H47I5t/abnormals_delight-1.19.2-4.1.2.jar" && \
    curl -sSL -o "mods/easy-villagers-forge-1.19.2-1.1.23.jar" \
        "https://cdn.modrinth.com/data/Kaov2qgi/versions/fT2nOKrM/easy-villagers-forge-1.19.2-1.1.23.jar" && \
    curl -sSL -o "mods/rechiseledcreate-1.0.2-forge-mc1.19.jar" \
        "https://cdn.modrinth.com/data/E6867niZ/versions/LZKMAa6P/rechiseledcreate-1.0.2-forge-mc1.19.jar" && \
    curl -sSL -o "mods/chat_heads-0.13.18-forge-1.19.2.jar" \
        "https://cdn.modrinth.com/data/Wb5oqrBJ/versions/AITeQaV9/chat_heads-0.13.18-forge-1.19.2.jar" && \
    curl -sSL -o "mods/curios-forge-1.19.2-5.1.6.4.jar" \
        "https://cdn.modrinth.com/data/vvuO3ImH/versions/uUAY30IE/curios-forge-1.19.2-5.1.6.4.jar" && \
    curl -sSL -o "mods/fastpaintings-1.19-1.1.3.jar" \
        "https://cdn.modrinth.com/data/z3TzcquW/versions/6yTegMt6/fastpaintings-1.19-1.1.3.jar" && \
    curl -sSL -o "mods/create_central_kitchen-1.19.2-for-create-0.5.1.f-1.3.11.c.jar" \
        "https://cdn.modrinth.com/data/btq68HMO/versions/xfrRlEVH/create_central_kitchen-1.19.2-for-create-0.5.1.f-1.3.11.c.jar" && \
    curl -sSL -o "mods/supermartijn642corelib-1.1.18-forge-mc1.19.2.jar" \
        "https://cdn.modrinth.com/data/rOUBggPv/versions/CjRX4qz1/supermartijn642corelib-1.1.18-forge-mc1.19.2.jar" && \
    curl -sSL -o "mods/labels-1.19.2-1.10.jar" \
        "https://cdn.modrinth.com/data/x6r7yhfi/versions/qAXckCmt/labels-1.19.2-1.10.jar" && \
    curl -sSL -o "mods/BetterTridents-v4.0.2-1.19.2-Forge.jar" \
        "https://cdn.modrinth.com/data/KNUSlHiU/versions/cWbBHrVq/BetterTridents-v4.0.2-1.19.2-Forge.jar" && \
    curl -sSL -o "mods/durabilitytooltip-1.1.6a-forge-mc1.19.jar" \
        "https://cdn.modrinth.com/data/smUP7V3r/versions/Da2nKmml/durabilitytooltip-1.1.6a-forge-mc1.19.jar" && \
    curl -sSL -o "mods/async-locator-forge-1.19.2-1.3.0.jar" \
        "https://cdn.modrinth.com/data/rkN8aqci/versions/8vNUDsod/async-locator-forge-1.19.2-1.3.0.jar" && \
    curl -sSL -o "mods/YungsBetterNetherFortresses-1.19.2-Forge-1.0.6.jar" \
        "https://cdn.modrinth.com/data/Z2mXHnxP/versions/9iPMgrMe/YungsBetterNetherFortresses-1.19.2-Forge-1.0.6.jar" && \
    curl -sSL -o "mods/respiteful-1.1.2.c.jar" \
        "https://cdn.modrinth.com/data/Df7RucLK/versions/NpcBHs0g/respiteful-1.1.2.c.jar" && \
    curl -sSL -o "mods/create_ca-2.1 - 1.19.2.jar" \
        "https://cdn.modrinth.com/data/exLPXAoq/versions/C3yr7wWy/create_ca-2.1%20-%201.19.2.jar" && \
    curl -sSL -o "mods/YungsBetterWitchHuts-1.19.2-Forge-2.1.0.jar" \
        "https://cdn.modrinth.com/data/t5FRdP87/versions/rAwSL8Wn/YungsBetterWitchHuts-1.19.2-Forge-2.1.0.jar" && \
    curl -sSL -o "mods/YungsBetterMineshafts-1.19.2-Forge-3.2.1.jar" \
        "https://cdn.modrinth.com/data/HjmxVlSr/versions/K4G8SGWy/YungsBetterMineshafts-1.19.2-Forge-3.2.1.jar" && \
    curl -sSL -o "mods/NMPR-1.19.2-1.1.1.jar" \
        "https://cdn.modrinth.com/data/6UbQDdoj/versions/UPaFjw3e/NMPR-1.19.2-1.1.1.jar" && \
    curl -sSL -o "mods/bedspreads-forge-6.0.0+1.19.2.jar" \
        "https://cdn.modrinth.com/data/vNNL5mc7/versions/nFsnpwRv/bedspreads-forge-6.0.0%2B1.19.2.jar" && \
    curl -sSL -o "mods/cloth-config-8.3.134-forge.jar" \
        "https://cdn.modrinth.com/data/9s6osm5g/versions/qqCHdFw2/cloth-config-8.3.134-forge.jar" && \
    curl -sSL -o "mods/pluto-mc1.19.2-0.0.9.jar" \
        "https://cdn.modrinth.com/data/I2K4u1Q7/versions/7JnXMAAf/pluto-mc1.19.2-0.0.9.jar" && \
    curl -sSL -o "mods/Paxi-1.19.2-Forge-3.0.1.jar" \
        "https://cdn.modrinth.com/data/CU0PAyzb/versions/nAUDoZw6/Paxi-1.19.2-Forge-3.0.1.jar" && \
    curl -sSL -o "mods/lootr-forge-1.19-0.4.29.76.jar" \
        "https://cdn.modrinth.com/data/EltpO5cN/versions/6ULhni05/lootr-forge-1.19-0.4.29.76.jar" && \
    curl -sSL -o "mods/trashslot-forge-1.19.2-12.1.0.jar" \
        "https://cdn.modrinth.com/data/vRYk0bv7/versions/VLnMeNCk/trashslot-forge-1.19.2-12.1.0.jar" && \
    curl -sSL -o "mods/omgourd-1.19.2-4.3.0.16.jar" \
        "https://cdn.modrinth.com/data/bUNifErl/versions/6wUddnfy/omgourd-1.19.2-4.3.0.16.jar" && \
    curl -sSL -o "mods/packetfixer-3.1.4-1.18-1.20.4-merged.jar" \
        "https://cdn.modrinth.com/data/c7m1mi73/versions/dCEO67fT/packetfixer-3.1.4-1.18-1.20.4-merged.jar" && \
    curl -sSL -o "mods/everycomp-1.19.2-2.5.35.jar" \
        "https://cdn.modrinth.com/data/eiktJyw1/versions/3iWAsz1Y/everycomp-1.19.2-2.5.35.jar" && \
    curl -sSL -o "mods/UniLib-1.1.1+1.19.2-forge.jar" \
        "https://cdn.modrinth.com/data/nT86WUER/versions/ap2vW2XY/UniLib-1.1.1%2B1.19.2-forge.jar" && \
    curl -sSL -o "mods/createbigcannons-5.6.0+mc.1.19.2-forge.jar" \
        "https://cdn.modrinth.com/data/GWp4jCJj/versions/SNKifNYV/createbigcannons-5.6.0%2Bmc.1.19.2-forge.jar" && \
    curl -sSL -o "mods/carryon-forge-1.19.2-2.1.2.23.jar" \
        "https://cdn.modrinth.com/data/joEfVgkn/versions/CE3MquDi/carryon-forge-1.19.2-2.1.2.23.jar" && \
    curl -sSL -o "mods/create_connected-0.9.4-mc1.19.2-all.jar" \
        "https://cdn.modrinth.com/data/Vg5TIO6d/versions/CLTrW9A5/create_connected-0.9.4-mc1.19.2-all.jar" && \
    curl -sSL -o "mods/mclogs-forge-1.4.2-1.19.jar" \
        "https://cdn.modrinth.com/data/6DdCzpTL/versions/c7Wk5o4r/mclogs-forge-1.4.2-1.19.jar" && \
    curl -sSL -o "mods/BedBenefits-Forge-1.19.2-9.1.3.jar" \
        "https://cdn.modrinth.com/data/Wl8l4Sim/versions/IfmFbXO5/BedBenefits-Forge-1.19.2-9.1.3.jar" && \
    curl -sSL -o "mods/KeepHeadNames-1.5.1-forge-1.19.jar" \
        "https://cdn.modrinth.com/data/2VmW47Rp/versions/1.5.1-forge-1.19/KeepHeadNames-1.5.1-forge-1.19.jar" && \
    curl -sSL -o "mods/memoryleakfix-forge-1.17+-1.1.5.jar" \
        "https://cdn.modrinth.com/data/NRjRiSSD/versions/3w0IxNtk/memoryleakfix-forge-1.17%2B-1.1.5.jar" && \
    curl -sSL -o "mods/cobweb-forge-1.19.2-1.0.1.jar" \
        "https://cdn.modrinth.com/data/dQcfqGbl/versions/vh4GHK4P/cobweb-forge-1.19.2-1.0.1.jar" && \
    curl -sSL -o "mods/MyNethersDelight-1.19-1.7.jar" \
        "https://cdn.modrinth.com/data/O53VhQoZ/versions/u8pJaV2E/MyNethersDelight-1.19-1.7.jar" && \
    curl -sSL -o "mods/pandalib-forge-mc1.19.2-0.5.2-SNAPSHOT.jar" \
        "https://cdn.modrinth.com/data/mEEGbEIu/versions/gD0PhYUh/pandalib-forge-mc1.19.2-0.5.2-SNAPSHOT.jar" && \
    curl -sSL -o "mods/extendedgears-2.1.1-1.19.2-0.5.1.f-forge.jar" \
        "https://cdn.modrinth.com/data/qO4lsa4Y/versions/a2OVeenK/extendedgears-2.1.1-1.19.2-0.5.1.f-forge.jar" && \
    curl -sSL -o "mods/boatload-1.19.2-4.2.2.jar" \
        "https://cdn.modrinth.com/data/hevpK888/versions/DDO9WQES/boatload-1.19.2-4.2.2.jar" && \
    curl -sSL -o "mods/molten_vents-1.19.2-2.0.8.jar" \
        "https://cdn.modrinth.com/data/uuVy6k1s/versions/2EHhuUtL/molten_vents-1.19.2-2.0.8.jar" && \
    curl -sSL -o "mods/oauth-1.1.15-1.19.2.jar" \
        "https://cdn.modrinth.com/data/K8pn1qHf/versions/WnKBQryy/oauth-1.1.15-1.19.2.jar" && \
    curl -sSL -o "mods/badpackets-forge-0.2.3.jar" \
        "https://cdn.modrinth.com/data/ftdbN0KK/versions/VTOW8XR6/badpackets-forge-0.2.3.jar" && \
    curl -sSL -o "mods/YungsBetterOceanMonuments-1.19.2-Forge-2.1.1.jar" \
        "https://cdn.modrinth.com/data/3dT9sgt4/versions/Uehc7tGO/YungsBetterOceanMonuments-1.19.2-Forge-2.1.1.jar" && \
    curl -sSL -o "mods/Necronomicon-Forge-1.4.2.jar" \
        "https://cdn.modrinth.com/data/P1Kv5EAO/versions/txeRRjSH/Necronomicon-Forge-1.4.2.jar" && \
    curl -sSL -o "mods/cofh_core-1.19.2-10.3.1.48.jar" \
        "https://cdn.modrinth.com/data/OWSRM4vD/versions/ssRHxD6e/cofh_core-1.19.2-10.3.1.48.jar" && \
    curl -sSL -o "mods/iwtb-1.1.jar" \
        "https://cdn.modrinth.com/data/SfXIxvDu/versions/6fOQd9fb/iwtb-1.1.jar" && \
    curl -sSL -o "mods/BadOptimizations-2.1.4-1.19.1-19.2.jar" \
        "https://cdn.modrinth.com/data/g96Z4WVZ/versions/iULB5JCQ/BadOptimizations-2.1.4-1.19.1-19.2.jar" && \
    curl -sSL -o "mods/Measurements-forge-1.19.2-1.3.2.jar" \
        "https://cdn.modrinth.com/data/wLINU2AB/versions/ZNlwakjv/Measurements-forge-1.19.2-1.3.2.jar" && \
    curl -sSL -o "mods/observable-3.3.1.jar" \
        "https://cdn.modrinth.com/data/VYRu7qmG/versions/nafMXhVc/observable-3.3.1.jar" && \
    curl -sSL -o "mods/portalsgui-1.0.1.jar" \
        "https://cdn.modrinth.com/data/kc2GyRHY/versions/abh53vCz/portalsgui-1.0.1.jar" && \
    curl -sSL -o "mods/mysterious_mountain_lib-1.2.3-1.19.2.jar" \
        "https://cdn.modrinth.com/data/ntMyNH8c/versions/Oe3zPknB/mysterious_mountain_lib-1.2.3-1.19.2.jar" && \
    curl -sSL -o "mods/berry_good-1.19.2-6.1.0.jar" \
        "https://cdn.modrinth.com/data/2WZWaKCl/versions/hpnxAvUC/berry_good-1.19.2-6.1.0.jar" && \
    curl -sSL -o "mods/rare-ice-0.5.1.jar" \
        "https://cdn.modrinth.com/data/uSi0tajU/versions/0.5.1/rare-ice-0.5.1.jar" && \
    curl -sSL -o "mods/elytraslot-forge-6.1.2+1.19.2.jar" \
        "https://cdn.modrinth.com/data/mSQF1NpT/versions/vH9hd5hp/elytraslot-forge-6.1.2%2B1.19.2.jar" && \
    curl -sSL -o "mods/sophisticatedbackpacks-1.19.2-3.20.2.1035.jar" \
        "https://cdn.modrinth.com/data/TyCTlI4b/versions/1TblkbcZ/sophisticatedbackpacks-1.19.2-3.20.2.1035.jar" && \
    curl -sSL -o "mods/Bookshelf-Forge-1.19.2-16.3.20.jar" \
        "https://cdn.modrinth.com/data/uy4Cnpcm/versions/IL6yVQcP/Bookshelf-Forge-1.19.2-16.3.20.jar" && \
    curl -sSL -o "mods/Clumps-forge-1.19.2-9.0.0+14.jar" \
        "https://cdn.modrinth.com/data/Wnxd13zP/versions/3GURrv52/Clumps-forge-1.19.2-9.0.0%2B14.jar" && \
    curl -sSL -o "mods/weakerspiderwebs-1.19.2-3.4.jar" \
        "https://cdn.modrinth.com/data/7L1HalIW/versions/P23h60QI/weakerspiderwebs-1.19.2-3.4.jar" && \
    curl -sSL -o "mods/canary-mc1.19.2-0.3.3.jar" \
        "https://cdn.modrinth.com/data/qa2H4BS9/versions/kbjigmpt/canary-mc1.19.2-0.3.3.jar" && \
    curl -sSL -o "mods/netherite_horse_armor-forge-1.19-1.0.4.jar" \
        "https://cdn.modrinth.com/data/nDFVOeq7/versions/EWW1OsYx/netherite_horse_armor-forge-1.19-1.0.4.jar" && \
    curl -sSL -o "mods/YungsExtras-1.19.2-Forge-3.1.0.jar" \
        "https://cdn.modrinth.com/data/ZYgyPyfq/versions/Ltax470w/YungsExtras-1.19.2-Forge-3.1.0.jar" && \
    curl -sSL -o "mods/create_enchantment_industry-1.19.2-for-create-0.5.1.f-1.2.9.e.jar" \
        "https://cdn.modrinth.com/data/JWGBpFUP/versions/KA5Gf4rg/create_enchantment_industry-1.19.2-for-create-0.5.1.f-1.2.9.e.jar" && \
    curl -sSL -o "mods/kleeslabs-forge-1.19.2-12.3.0.jar" \
        "https://cdn.modrinth.com/data/7uh75ruZ/versions/OabgLyDQ/kleeslabs-forge-1.19.2-12.3.0.jar" && \
    curl -sSL -o "mods/another_furniture-forge-1.19.2-2.1.4.jar" \
        "https://cdn.modrinth.com/data/ulloLmqG/versions/b6EO57JG/another_furniture-forge-1.19.2-2.1.4.jar" && \
    curl -sSL -o "mods/geckolib-forge-1.19-3.1.40.jar" \
        "https://cdn.modrinth.com/data/8BmcQJ2H/versions/lxzmD9V4/geckolib-forge-1.19-3.1.40.jar" && \
    curl -sSL -o "mods/emi-1.1.22+1.19.2+forge.jar" \
        "https://cdn.modrinth.com/data/fRiHVvU7/versions/arXvHNCO/emi-1.1.22%2B1.19.2%2Bforge.jar" && \
    curl -sSL -o "mods/cakechomps-forge-6.0.0+1.19.2.jar" \
        "https://cdn.modrinth.com/data/g646EoqQ/versions/k4jAIv2y/cakechomps-forge-6.0.0%2B1.19.2.jar" && \
    curl -sSL -o "mods/emi_loot-0.6.6+fix4+1.19.2+forge.jar" \
        "https://cdn.modrinth.com/data/qbbO7Jns/versions/VhcPzhEp/emi_loot-0.6.6%2Bfix4%2B1.19.2%2Bforge.jar" && \
    curl -sSL -o "mods/glassbreaker-forge-1.4.0+1.18.2.jar" \
        "https://cdn.modrinth.com/data/vY7Ka6pe/versions/zcti3vd6/glassbreaker-forge-1.4.0%2B1.18.2.jar" && \
    curl -sSL -o "mods/PuzzlesLib-v4.4.3-1.19.2-Forge.jar" \
        "https://cdn.modrinth.com/data/QAGBst4M/versions/UbCrBSit/PuzzlesLib-v4.4.3-1.19.2-Forge.jar" && \
    curl -sSL -o "mods/allurement-1.19.2-3.2.1.jar" \
        "https://cdn.modrinth.com/data/eIO12l2t/versions/O9J4Ktag/allurement-1.19.2-3.2.1.jar" && \
    curl -sSL -o "mods/kotlinforforge-3.12.0-all.jar" \
        "https://cdn.modrinth.com/data/ordsPcFz/versions/NBn3sEQk/kotlinforforge-3.12.0-all.jar" && \
    curl -sSL -o "mods/FarmersDelight-1.19.2-1.2.4.jar" \
        "https://cdn.modrinth.com/data/R2OftAxM/versions/rFTKVUtq/FarmersDelight-1.19.2-1.2.4.jar" && \
    curl -sSL -o "mods/FiveHead-1.19.2-2.0.2.jar" \
        "https://cdn.modrinth.com/data/2n7aYFjU/versions/28ahj8U6/FiveHead-1.19.2-2.0.2.jar" && \
    curl -sSL -o "mods/curiouslanterns-1.19.2-1.3.7.jar" \
        "https://cdn.modrinth.com/data/cE5SLYbv/versions/rFrwOluN/curiouslanterns-1.19.2-1.3.7.jar" && \
    curl -sSL -o "mods/neapolitan-1.19.2-4.1.0.jar" \
        "https://cdn.modrinth.com/data/InYMuiQt/versions/8qmVV9M7/neapolitan-1.19.2-4.1.0.jar" && \
    curl -sSL -o "mods/ecologics-forge-1.19.2-2.1.11.jar" \
        "https://cdn.modrinth.com/data/NCKpPR0Z/versions/hOFm4e6B/ecologics-forge-1.19.2-2.1.11.jar" && \
    curl -sSL -o "mods/create-1.19.2-0.5.1.i.jar" \
        "https://cdn.modrinth.com/data/LNytGWDc/versions/tJVykywJ/create-1.19.2-0.5.1.i.jar" && \
    curl -sSL -o "mods/tetra-1.19.2-5.6.0.jar" \
        "https://cdn.modrinth.com/data/YP9DjOvN/versions/tj9wtOla/tetra-1.19.2-5.6.0.jar" && \
    curl -sSL -o "mods/Kiwi-1.19.2-forge-8.3.6.jar" \
        "https://cdn.modrinth.com/data/ufdDoWPd/versions/yQbhR062/Kiwi-1.19.2-forge-8.3.6.jar" && \
    curl -sSL -o "mods/superflatworldnoslimes-1.19.2-3.2.jar" \
        "https://cdn.modrinth.com/data/7lrBqj5C/versions/dVr87WJX/superflatworldnoslimes-1.19.2-3.2.jar" && \
    curl -sSL -o "mods/corpse-forge-1.19.2-1.0.17.jar" \
        "https://cdn.modrinth.com/data/WrpuIfhw/versions/ofDmBZke/corpse-forge-1.19.2-1.0.17.jar" && \
    curl -sSL -o "mods/trading_floor-1.1.5+forge-1.19.2.jar" \
        "https://cdn.modrinth.com/data/WROfLLvn/versions/rK1cR4Mh/trading_floor-1.1.5%2Bforge-1.19.2.jar" && \
    curl -sSL -o "mods/collective-1.19.2-7.64.jar" \
        "https://cdn.modrinth.com/data/e0M1UDsY/versions/RKCtWE4y/collective-1.19.2-7.64.jar" && \
    curl -sSL -o "mods/coroutil-forge-1.19.2-1.3.6.jar" \
        "https://cdn.modrinth.com/data/rLLJ1OZM/versions/ZgPJI4Kz/coroutil-forge-1.19.2-1.3.6.jar" && \
    curl -sSL -o "mods/bettersafebed-forge-1.19-4.jar" \
        "https://cdn.modrinth.com/data/aUp4r9hY/versions/bettersafebed-forge-1.19-4/bettersafebed-forge-1.19-4.jar" && \
    curl -sSL -o "mods/smarterfarmers-1.19.2-1.7.1.jar" \
        "https://cdn.modrinth.com/data/Bh6ZOMvp/versions/WO7QFUFi/smarterfarmers-1.19.2-1.7.1.jar" && \
    curl -sSL -o "mods/randomshulkercolours-1.19.2-3.2.jar" \
        "https://cdn.modrinth.com/data/mT4tJQIo/versions/ginoQfnO/randomshulkercolours-1.19.2-3.2.jar" && \
    curl -sSL -o "mods/creeper_firework-1.19.2-1.2.0.jar" \
        "https://cdn.modrinth.com/data/owUiXPam/versions/jrq6JT6B/creeper_firework-1.19.2-1.2.0.jar" && \
    curl -sSL -o "mods/Pehkui-3.8.2+1.19.2-forge.jar" \
        "https://cdn.modrinth.com/data/t5W7Jfwy/versions/pJSHElpS/Pehkui-3.8.2%2B1.19.2-forge.jar" && \
    curl -sSL -o "mods/createframed-1.19.2-1.4.5.1.jar" \
        "https://cdn.modrinth.com/data/15fFZ3f4/versions/h9ixfoTK/createframed-1.19.2-1.4.5.1.jar" && \
    curl -sSL -o "mods/responsiveshields-2.3-mc1.18-19-20.x.jar" \
        "https://cdn.modrinth.com/data/MBmh0f9A/versions/6vuwab6O/responsiveshields-2.3-mc1.18-19-20.x.jar" && \
    curl -sSL -o "mods/YungsApi-1.19.2-Forge-3.8.10.jar" \
        "https://cdn.modrinth.com/data/Ua7DFN59/versions/L5GqhLVE/YungsApi-1.19.2-Forge-3.8.10.jar" && \
    curl -sSL -o "mods/comforts-forge-6.0.7+1.19.2.jar" \
        "https://cdn.modrinth.com/data/SaCpeal4/versions/4xI610Ck/comforts-forge-6.0.7%2B1.19.2.jar"

# =============================================================================
# Runtime stage
# =============================================================================
FROM eclipse-temurin:17-jre

WORKDIR /server

# Copy Forge server files
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
