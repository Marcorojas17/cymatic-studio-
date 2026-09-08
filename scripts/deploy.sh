#!/usr/bin/env bash
# ============================================================
# CYMATIC STUDIO v24 · DEPLOY SCRIPT
# Despliegue automatizado a Netlify, Vercel o AWS S3.
# ============================================================
# Uso:
#   ./deploy.sh [netlify|vercel|aws]
#   ./deploy.sh netlify   → Despliega a Netlify
#   ./deploy.sh vercel    → Despliega a Vercel
#   ./deploy.sh aws       → Despliega a AWS S3
# ============================================================

set -e  # Detener ejecución si ocurre cualquier error

# ----- 1. COLORES Y ESTILOS -----
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ----- 2. FUNCIÓN DE AYUDA -----
show_help() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     CYMATIC STUDIO v24 · DEPLOY SCRIPT                  ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Uso:${NC} $0 [netlify|vercel|aws]"
    echo ""
    echo -e "${YELLOW}Opciones:${NC}"
    echo "  netlify   Despliega a Netlify (requiere netlify-cli)"
    echo "  vercel    Despliega a Vercel (requiere vercel-cli)"
    echo "  aws       Despliega a AWS S3 (requiere aws-cli)"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0 netlify"
    echo "  $0 vercel"
    echo "  $0 aws"
    echo ""
    echo -e "${YELLOW}Variables de entorno necesarias:${NC}"
    echo "  NETLIFY_AUTH_TOKEN   → Token de autenticación de Netlify"
    echo "  NETLIFY_SITE_ID      → ID del sitio en Netlify"
    echo "  VERCEL_TOKEN         → Token de autenticación de Vercel"
    echo "  AWS_ACCESS_KEY_ID    → Clave de acceso de AWS"
    echo "  AWS_SECRET_ACCESS_KEY→ Clave secreta de AWS"
    echo "  AWS_BUCKET_NAME      → Nombre del bucket S3"
    echo "  AWS_REGION           → Región de AWS (ej. us-east-1)"
    echo ""
    echo -e "${YELLOW}Pre-requisitos:${NC}"
    echo "  • Tener instalado el CLI correspondiente (netlify-cli, vercel-cli, aws-cli)"
    echo "  • Tener configuradas las variables de entorno"
    echo ""
}

# ----- 3. VALIDACIÓN DE ARGUMENTOS -----
if [ $# -lt 1 ]; then
    echo -e "${RED}❌ Error: Debes especificar un destino.${NC}"
    show_help
    exit 1
fi

TARGET="$1"
shift

case "$TARGET" in
    netlify|vercel|aws)
        echo -e "${GREEN}✅ Destino seleccionado:${NC} $TARGET"
        ;;
    help|--help|-h)
        show_help
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Error: Destino inválido.${NC}"
        show_help
        exit 1
        ;;
esac

# ----- 4. FUNCIONES DE DESPLIEGUE -----
deploy_netlify() {
    echo -e "${BLUE}🚀 Desplegando a Netlify...${NC}"
    
    # Verificar que netlify-cli esté instalado
    if ! command -v netlify &> /dev/null; then
        echo -e "${RED}❌ netlify-cli no está instalado.${NC}"
        echo -e "${YELLOW}📦 Instálalo con: npm install -g netlify-cli${NC}"
        exit 1
    fi

    # Verificar variables de entorno
    if [ -z "$NETLIFY_AUTH_TOKEN" ] || [ -z "$NETLIFY_SITE_ID" ]; then
        echo -e "${RED}❌ Faltan variables de entorno: NETLIFY_AUTH_TOKEN y NETLIFY_SITE_ID.${NC}"
        echo -e "${YELLOW}📌 Configúralas en tu entorno o en un archivo .env.${NC}"
        exit 1
    fi

    # Construir el sitio (si hay build, de lo contrario solo copiar)
    if [ -f "package.json" ] && grep -q '"build"' package.json; then
        echo -e "${BLUE}🔨 Ejecutando build...${NC}"
        npm run build
    else
        echo -e "${YELLOW}⚠️ No se encontró script de build. Se desplegarán los archivos estáticos.${NC}"
    fi

    # Desplegar a Netlify
    echo -e "${BLUE}📤 Subiendo archivos a Netlify...${NC}"
    netlify deploy \
        --auth "$NETLIFY_AUTH_TOKEN" \
        --site "$NETLIFY_SITE_ID" \
        --dir "./" \
        --prod \
        --json || {
        echo -e "${RED}❌ Falló el despliegue a Netlify.${NC}"
        exit 1
    }

    echo -e "${GREEN}✅ Despliegue a Netlify completado con éxito.${NC}"
}

deploy_vercel() {
    echo -e "${BLUE}🚀 Desplegando a Vercel...${NC}"
    
    # Verificar que vercel-cli esté instalado
    if ! command -v vercel &> /dev/null; then
        echo -e "${RED}❌ vercel-cli no está instalado.${NC}"
        echo -e "${YELLOW}📦 Instálalo con: npm install -g vercel${NC}"
        exit 1
    fi

    # Verificar variables de entorno
    if [ -z "$VERCEL_TOKEN" ]; then
        echo -e "${RED}❌ Faltan variables de entorno: VERCEL_TOKEN.${NC}"
        exit 1
    fi

    # Desplegar a Vercel (producción)
    echo -e "${BLUE}📤 Subiendo archivos a Vercel...${NC}"
    vercel --prod --token "$VERCEL_TOKEN" --confirm || {
        echo -e "${RED}❌ Falló el despliegue a Vercel.${NC}"
        exit 1
    }

    echo -e "${GREEN}✅ Despliegue a Vercel completado con éxito.${NC}"
}

deploy_aws() {
    echo -e "${BLUE}🚀 Desplegando a AWS S3...${NC}"
    
    # Verificar que aws-cli esté instalado
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}❌ aws-cli no está instalado.${NC}"
        echo -e "${YELLOW}📦 Instálalo siguiendo: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html${NC}"
        exit 1
    fi

    # Verificar variables de entorno
    if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_BUCKET_NAME" ] || [ -z "$AWS_REGION" ]; then
        echo -e "${RED}❌ Faltan variables de entorno de AWS.${NC}"
        echo -e "${YELLOW}📌 Requiere: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_BUCKET_NAME, AWS_REGION${NC}"
        exit 1
    fi

    # Configurar AWS CLI (usar variables de entorno)
    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_DEFAULT_REGION="$AWS_REGION"

    # Sincronizar archivos con S3
    echo -e "${BLUE}📤 Subiendo archivos a S3 (bucket: $AWS_BUCKET_NAME)...${NC}"
    aws s3 sync . "s3://$AWS_BUCKET_NAME" \
        --delete \
        --exclude ".git/*" \
        --exclude "*.log" \
        --exclude ".env*" \
        --exclude "node_modules/*" \
        --acl public-read \
        --cache-control "max-age=86400" || {
        echo -e "${RED}❌ Falló la sincronización con S3.${NC}"
        exit 1
    }

    echo -e "${GREEN}✅ Archivos subidos a S3.${NC}"

    # Opcional: invalidar CloudFront si está configurado
    if [ ! -z "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
        echo -e "${BLUE}🔄 Invalidando caché de CloudFront...${NC}"
        aws cloudfront create-invalidation \
            --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
            --paths "/*" || {
            echo -e "${YELLOW}⚠️ No se pudo invalidar CloudFront.${NC}"
        }
        echo -e "${GREEN}✅ Caché de CloudFront invalidada.${NC}"
    fi

    echo -e "${GREEN}✅ Despliegue a AWS completado con éxito.${NC}"
}

# ----- 5. EJECUCIÓN DEL DESPLIEGUE -----
case "$TARGET" in
    netlify)
        deploy_netlify
        ;;
    vercel)
        deploy_vercel
        ;;
    aws)
        deploy_aws
        ;;
esac

echo -e "${GREEN}🎉 ¡CYMATIC STUDIO desplegado correctamente en $TARGET!${NC}"
echo -e "${BLUE}🌐 Visita tu sitio para ver los cambios.${NC}"
