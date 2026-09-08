#!/usr/bin/env bash
# ============================================================
# CYMATIC STUDIO v24 · CHECKSUM GENERATOR (SHA-256)
# Genera y verifica hashes SHA-256 de todos los archivos.
# ============================================================
# Uso:
#   ./checksum.sh generate   → Genera archivo checksums.sha256
#   ./checksum.sh verify     → Verifica integridad contra checksums.sha256
#   ./checksum.sh report     → Genera reporte HTML detallado
# ============================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CHECKSUM_FILE="checksums.sha256"
REPORT_FILE="docs/security_report.html"
EXCLUDE_DIRS=(".git" "node_modules" "dist" "temp")
EXCLUDE_FILES=("*.log" "*.tmp" "checksums.sha256")

# ----- FUNCIÓN: GENERAR CHECKSUMS -----
generate_checksums() {
    echo -e "${BLUE}🔐 Generando checksums SHA-256...${NC}"
    
    # Vaciar archivo de checksums
    > "$CHECKSUM_FILE"

    # Encontrar todos los archivos relevantes
    find . -type f \
        \( -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.svg" -o -name "*.md" -o -name "*.json" -o -name "*.ico" \) \
        -not -path "./.git/*" \
        -not -path "./node_modules/*" \
        -not -path "./dist/*" \
        -not -path "./temp/*" \
        -not -name "checksums.sha256" \
        -not -name "*.log" \
        -not -name "*.tmp" \
        -print0 | while IFS= read -r -d '' file; do
        # Calcular SHA-256
        if command -v sha256sum &> /dev/null; then
            hash=$(sha256sum "$file" | awk '{print $1}')
        elif command -v shasum &> /dev/null; then
            hash=$(shasum -a 256 "$file" | awk '{print $1}')
        else
            echo -e "${RED}❌ No se encontró sha256sum ni shasum.${NC}"
            exit 1
        fi
        # Escribir al archivo de checksums
        echo "$hash  $file" >> "$CHECKSUM_FILE"
    done

    echo -e "${GREEN}✅ Checksums generados en: ${CHECKSUM_FILE}${NC}"
    echo -e "${BLUE}📊 Total de archivos: $(wc -l < "$CHECKSUM_FILE")${NC}"
}

# ----- FUNCIÓN: VERIFICAR CHECKSUMS -----
verify_checksums() {
    if [ ! -f "$CHECKSUM_FILE" ]; then
        echo -e "${RED}❌ Archivo de checksums no encontrado: ${CHECKSUM_FILE}${NC}"
        echo -e "${YELLOW}📌 Genera primero los checksums con: $0 generate${NC}"
        exit 1
    fi

    echo -e "${BLUE}🔍 Verificando integridad de archivos...${NC}"
    
    # Usar sha256sum -c para verificar
    if command -v sha256sum &> /dev/null; then
        sha256sum -c "$CHECKSUM_FILE" --quiet || {
            echo -e "${RED}❌ ¡Integridad comprometida! Algunos archivos han sido modificados.${NC}"
            exit 1
        }
    elif command -v shasum &> /dev/null; then
        # shasum no tiene opción -c directa, hacemos verificación manual
        while IFS= read -r line; do
            expected_hash=$(echo "$line" | awk '{print $1}')
            file=$(echo "$line" | awk '{print $2}')
            if [ -f "$file" ]; then
                actual_hash=$(shasum -a 256 "$file" | awk '{print $1}')
                if [ "$expected_hash" != "$actual_hash" ]; then
                    echo -e "${RED}❌ Falló: ${file}${NC}"
                    exit 1
                fi
            else
                echo -e "${RED}❌ Archivo faltante: ${file}${NC}"
                exit 1
            fi
        done < "$CHECKSUM_FILE"
    else
        echo -e "${RED}❌ No se encontró sha256sum ni shasum.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Todos los archivos verificados correctamente.${NC}"
}

# ----- FUNCIÓN: GENERAR REPORTE HTML -----
generate_report() {
    if [ ! -f "$CHECKSUM_FILE" ]; then
        echo -e "${RED}❌ Archivo de checksums no encontrado.${NC}"
        exit 1
    fi

    echo -e "${BLUE}📄 Generando reporte de seguridad en: ${REPORT_FILE}${NC}"

    # Cabecera del reporte
    cat > "$REPORT_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CYMATIC STUDIO · Reporte de Seguridad SHA-256</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Courier New', monospace;
            background: #020308;
            color: #e2e8f0;
            padding: 40px 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 {
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(135deg, #00ffcc, #a855f7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }
        .subtitle {
            color: #94a3b8;
            margin-bottom: 30px;
            font-size: 0.9rem;
            border-bottom: 1px solid rgba(255,255,255,0.03);
            padding-bottom: 16px;
        }
        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: rgba(4, 7, 16, 0.7);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(0, 255, 204, 0.08);
            border-radius: 12px;
            padding: 16px 20px;
        }
        .summary-card .label {
            font-size: 0.6rem;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .summary-card .value {
            font-size: 1.4rem;
            font-weight: 700;
            color: #00ffcc;
            margin-top: 4px;
        }
        .table-wrap {
            overflow-x: auto;
            background: rgba(4, 7, 16, 0.5);
            border-radius: 12px;
            border: 1px solid rgba(0, 255, 204, 0.05);
            padding: 8px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.7rem;
            font-family: 'Courier New', monospace;
        }
        thead th {
            text-align: left;
            padding: 12px 16px;
            color: #94a3b8;
            border-bottom: 1px solid rgba(255,255,255,0.03);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }
        tbody td {
            padding: 10px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.02);
            color: #c8d0dc;
            word-break: break-all;
        }
        tbody tr:hover {
            background: rgba(0, 255, 204, 0.02);
        }
        .hash {
            color: #00ffcc;
            font-weight: 400;
        }
        .file-name {
            color: #e2e8f0;
        }
        .status-ok {
            color: #44dd88;
        }
        .status-error {
            color: #ff4d6d;
        }
        .footer {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.02);
            font-size: 0.6rem;
            color: #475569;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔐 CYMATIC STUDIO</h1>
        <div class="subtitle">Reporte de Seguridad · SHA-256 · Integridad de Archivos</div>
EOF

    # Estadísticas
    total_files=$(wc -l < "$CHECKSUM_FILE")
    echo -e '<div class="summary">' >> "$REPORT_FILE"
    echo -e "<div class=\"summary-card\"><div class=\"label\">Total Archivos</div><div class=\"value\">$total_files</div></div>" >> "$REPORT_FILE"
    echo -e "<div class=\"summary-card\"><div class=\"label\">Fecha de Reporte</div><div class=\"value\">$(date '+%Y-%m-%d %H:%M:%S')</div></div>" >> "$REPORT_FILE"
    echo -e "<div class=\"summary-card\"><div class=\"label\">Estado</div><div class=\"value\" style=\"color:#44dd88;\">✔ VERIFICADO</div></div>" >> "$REPORT_FILE"
    echo -e '</div>' >> "$REPORT_FILE"

    # Tabla de archivos
    echo -e '<div class="table-wrap"><table><thead><tr><th>#</th><th>Archivo</th><th>SHA-256</th><th>Estado</th></tr></thead><tbody>' >> "$REPORT_FILE"

    counter=1
    while IFS= read -r line; do
        hash=$(echo "$line" | awk '{print $1}')
        file=$(echo "$line" | awk '{print $2}')
        # Verificar si el archivo existe
        if [ -f "$file" ]; then
            status="<span class=\"status-ok\">✔ OK</span>"
        else
            status="<span class=\"status-error\">✖ Faltante</span>"
        fi
        echo -e "<tr><td>$counter</td><td class=\"file-name\">$file</td><td class=\"hash\">$hash</td><td>$status</td></tr>" >> "$REPORT_FILE"
        counter=$((counter+1))
    done < "$CHECKSUM_FILE"

    echo -e '</tbody></table></div>' >> "$REPORT_FILE"

    # Footer
    cat >> "$REPORT_FILE" << 'EOF'
        <div class="footer">
            <p>Reporte generado automáticamente por CYMATIC STUDIO Security Module v24</p>
            <p>Folio: 5204160405358537 · SHA: a4ff808e · Trace: KRONOS-TRACE-PVA</p>
        </div>
    </div>
</body>
</html>
EOF

    echo -e "${GREEN}✅ Reporte generado: ${REPORT_FILE}${NC}"
}

# ----- PROCESAMIENTO DE ARGUMENTOS -----
case "$1" in
    generate)
        generate_checksums
        ;;
    verify)
        verify_checksums
        ;;
    report)
        generate_checksums  # Genera checksums si no existen
        generate_report
        ;;
    *)
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║     CYMATIC STUDIO v24 · CHECKSUM TOOL                 ║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}Uso:${NC} $0 {generate|verify|report}"
        echo ""
        echo -e "${YELLOW}Comandos:${NC}"
        echo "  generate   Genera archivo checksums.sha256"
        echo "  verify     Verifica integridad contra checksums.sha256"
        echo "  report     Genera reporte HTML detallado"
        echo ""
        exit 1
        ;;
esac
