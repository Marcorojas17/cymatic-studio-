#!/usr/bin/env bash
# ============================================================
# CYMATIC STUDIO v24 · MINIFY SCRIPT
# Optimización de recursos: CSS y JS para producción.
# ============================================================
# Uso:
#   ./minify.sh           → Minifica todos los archivos CSS/JS
#   ./minify.sh --watch   → Modo vigilancia (minifica al cambiar)
#   ./minify.sh --help    → Muestra esta ayuda
# ============================================================

set -e

# ----- 1. COLORES Y ESTILOS -----
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ----- 2. CONFIGURACIÓN -----
CSS_DIR="assets/css"
JS_DIR="assets/js"
OUTPUT_DIR="dist"
WATCH_MODE=false

# Verificar dependencias
check_dependencies() {
    local missing=()
    if ! command -v terser &> /dev/null; then
        missing+=("terser (npm install -g terser)")
    fi
    if ! command -v cssnano &> /dev/null; then
        missing+=("cssnano-cli (npm install -g cssnano-cli)")
    fi

    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${RED}❌ Faltan dependencias:${NC}"
        for dep in "${missing[@]}"; do
            echo -e "  ${YELLOW}• ${dep}${NC}"
        done
        echo -e "${YELLOW}📦 Instálalas con: npm install -g terser cssnano-cli${NC}"
        exit 1
    fi
}

# ----- 3. FUNCIONES DE MINIFICACIÓN -----
minify_css() {
    local src="$1"
    local dst="$2"
    echo -e "${BLUE}📦 Minificando CSS:${NC} $src → $dst"
    cssnano "$src" "$dst" --config cssnano.config.js || {
        echo -e "${RED}❌ Error minificando CSS: $src${NC}"
        return 1
    }
    echo -e "${GREEN}✅ CSS minificado:${NC} $dst"
}

minify_js() {
    local src="$1"
    local dst="$2"
    echo -e "${BLUE}📦 Minificando JS:${NC} $src → $dst"
    terser "$src" \
        --compress \
        --mangle \
        --output "$dst" \
        --comments false \
        --source-map "url=${dst}.map" || {
        echo -e "${RED}❌ Error minificando JS: $src${NC}"
        return 1
    }
    echo -e "${GREEN}✅ JS minificado:${NC} $dst"
}

# ----- 4. FUNCIÓN PRINCIPAL DE MINIFICACIÓN -----
process_assets() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     CYMATIC STUDIO v24 · MINIFY SCRIPT                 ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Crear directorio de salida si no existe
    mkdir -p "$OUTPUT_DIR/$CSS_DIR" "$OUTPUT_DIR/$JS_DIR"

    # ----- Minificar CSS -----
    echo -e "${YELLOW}=== Minificando archivos CSS ===${NC}"
    if [ -d "$CSS_DIR" ]; then
        for file in "$CSS_DIR"/*.css; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                # Evitar re-minificar archivos ya minificados
                if [[ "$filename" != *.min.css ]]; then
                    minify_css "$file" "$OUTPUT_DIR/$CSS_DIR/${filename%.css}.min.css"
                fi
            fi
        done
    else
        echo -e "${YELLOW}⚠️ Directorio CSS no encontrado: $CSS_DIR${NC}"
    fi

    # ----- Minificar JavaScript -----
    echo -e "\n${YELLOW}=== Minificando archivos JavaScript ===${NC}"
    if [ -d "$JS_DIR" ]; then
        for file in "$JS_DIR"/*.js; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                # Evitar re-minificar archivos ya minificados
                if [[ "$filename" != *.min.js ]]; then
                    minify_js "$file" "$OUTPUT_DIR/$JS_DIR/${filename%.js}.min.js"
                fi
            fi
        done
    else
        echo -e "${YELLOW}⚠️ Directorio JS no encontrado: $JS_DIR${NC}"
    fi

    echo -e "\n${GREEN}✅ Proceso de minificación completado.${NC}"
    echo -e "${BLUE}📂 Archivos minificados en: ${OUTPUT_DIR}/${NC}"
}

# ----- 5. MODO VIGILANCIA (WATCH) -----
watch_assets() {
    echo -e "${BLUE}👀 Modo vigilancia activado. Minificando al cambiar archivos...${NC}"
    echo -e "${YELLOW}Presiona Ctrl+C para detener.${NC}"

    # Usar fswatch si está disponible, o inotifywait en Linux
    if command -v fswatch &> /dev/null; then
        fswatch -o "$CSS_DIR" "$JS_DIR" | while read; do
            echo -e "\n${YELLOW}🔄 Cambio detectado. Re-minificando...${NC}"
            process_assets
        done
    elif command -v inotifywait &> /dev/null; then
        inotifywait -m -r -e modify,create,delete "$CSS_DIR" "$JS_DIR" | while read; do
            echo -e "\n${YELLOW}🔄 Cambio detectado. Re-minificando...${NC}"
            process_assets
        done
    else
        echo -e "${RED}❌ No se encontró herramienta de vigilancia.${NC}"
        echo -e "${YELLOW}📌 Instala fswatch (macOS) o inotify-tools (Linux).${NC}"
        echo -e "${YELLOW}   macOS: brew install fswatch${NC}"
        echo -e "${YELLOW}   Linux: sudo apt-get install inotify-tools${NC}"
        exit 1
    fi
}

# ----- 6. FUNCIÓN DE AYUDA -----
show_help() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     CYMATIC STUDIO v24 · MINIFY SCRIPT                 ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Uso:${NC} $0 [--watch] [--help]"
    echo ""
    echo -e "${YELLOW}Opciones:${NC}"
    echo "  --watch    Modo vigilancia: minifica automáticamente al cambiar archivos"
    echo "  --help     Muestra esta ayuda"
    echo ""
    echo -e "${YELLOW}Requisitos:${NC}"
    echo "  • terser (npm install -g terser)"
    echo "  • cssnano-cli (npm install -g cssnano-cli)"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0              → Minifica una sola vez"
    echo "  $0 --watch      → Minifica continuamente"
    echo ""
}

# ----- 7. PROCESAMIENTO DE ARGUMENTOS -----
case "$1" in
    --watch)
        WATCH_MODE=true
        ;;
    --help|-h)
        show_help
        exit 0
        ;;
    "")
        # Sin argumentos, ejecutar una sola vez
        ;;
    *)
        echo -e "${RED}❌ Opción desconocida: $1${NC}"
        show_help
        exit 1
        ;;
esac

# ----- 8. EJECUCIÓN -----
check_dependencies

if [ "$WATCH_MODE" = true ]; then
    watch_assets
else
    process_assets
fi
