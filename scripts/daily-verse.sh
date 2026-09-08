#!/usr/bin/env bash
# ============================================================
# Versículo del Día — Reina Valera 1960 (RVR1960)
# Repositorio: pipeaalzamora/Dotfiles
# Paleta: Catppuccin Mocha | Formato: Terminal, Notificación y Widget
# ============================================================

set -eo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DB_FILE="$DOTFILES_DIR/data/bible-rvr1960.json"
CACHE_DIR="$HOME/.cache"
CACHE_JSON="$CACHE_DIR/daily-verse.json"
CACHE_TXT="$CACHE_DIR/daily-verse.txt"

if [ ! -f "$DB_FILE" ]; then
    echo "❌ Error: Base de datos no encontrada en $DB_FILE" >&2
    exit 1
fi

CATEGORY="${1:-random}"

# Procesar con jq o con Python como fallback
get_verse() {
    local cat="$1"
    if command -v jq &>/dev/null; then
        local filter='.verses[]'
        case "${cat,,}" in
            salmo|salmos) filter='.verses[] | select(.category == "salmo")' ;;
            proverbio|proverbios) filter='.verses[] | select(.category == "proverbio")' ;;
            promesa|promesas) filter='.verses[] | select(.category == "promesa")' ;;
        esac
        jq -c -s "[$filter] | .[(now * 1000 | floor) % length]" "$DB_FILE" 2>/dev/null || jq -c '.verses[0]' "$DB_FILE"
    elif command -v python3 &>/dev/null || command -v python &>/dev/null; then
        local py_cmd="python3"
        command -v python3 &>/dev/null || py_cmd="python"
        "$py_cmd" - "$DB_FILE" "$cat" << 'PYEOF'
import json, random, sys
db_file = sys.argv[1]
cat = sys.argv[2].lower() if len(sys.argv) > 2 else "random"
try:
    with open(db_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    verses = data.get('verses', [])
    if cat in ['salmo', 'salmos']:
        filtered = [v for v in verses if v.get('category') == 'salmo']
    elif cat in ['proverbio', 'proverbios']:
        filtered = [v for v in verses if v.get('category') == 'proverbio']
    elif cat in ['promesa', 'promesas']:
        filtered = [v for v in verses if v.get('category') == 'promesa']
    else:
        filtered = verses
    choice = random.choice(filtered) if filtered else verses[0]
    print(json.dumps(choice, ensure_ascii=False))
except Exception:
    print('{"reference":"Salmos 23:1","text":"Jehová es mi pastor; nada me faltará."}')
PYEOF
    else
        echo '{"reference":"Salmos 23:1","text":"Jehová es mi pastor; nada me faltará."}'
    fi
}

VERSE_JSON=$(get_verse "$CATEGORY")

# Extraer referencia y texto
if command -v jq &>/dev/null; then
    REF=$(echo "$VERSE_JSON" | jq -r '.reference // "RVR1960"')
    TEXT=$(echo "$VERSE_JSON" | jq -r '.text // ""')
elif command -v python3 &>/dev/null || command -v python &>/dev/null; then
    local_py="python3"
    command -v python3 &>/dev/null || local_py="python"
    REF=$("$local_py" -c "import json, sys; print(json.loads(sys.argv[1]).get('reference', 'RVR1960'))" "$VERSE_JSON")
    TEXT=$("$local_py" -c "import json, sys; print(json.loads(sys.argv[1]).get('text', ''))" "$VERSE_JSON")
else
    REF="Salmos 23:1"
    TEXT="Jehová es mi pastor; nada me faltará."
fi

# Guardar en caché para widgets, plasmoids y barras de estado
mkdir -p "$CACHE_DIR" 2>/dev/null || true
echo "$VERSE_JSON" > "$CACHE_JSON" 2>/dev/null || true
printf "«%s»\n— %s (RVR1960)\n" "$TEXT" "$REF" > "$CACHE_TXT" 2>/dev/null || true

MODE="${1:-terminal}"
[ "$MODE" = "salmo" ] || [ "$MODE" = "proverbio" ] || [ "$MODE" = "promesa" ] && MODE="terminal"
[ -n "${2:-}" ] && MODE="$2"

case "$MODE" in
    json)
        echo "$VERSE_JSON"
        ;;
    notify|notif)
        if command -v notify-send &>/dev/null; then
            notify-send \
                -a "Palabra de Dios" \
                -i "bookmarks" \
                -u normal \
                -t 12000 \
                "📖 Reina Valera 1960 · $REF" \
                "«$TEXT»"
        fi
        ;;
    raw)
        echo -e "«$TEXT» — $REF"
        ;;
    terminal|text|*)
        LAVENDER='\033[38;2;180;190;254m'
        BLUE='\033[38;2;137;180;250m'
        TEXT_COL='\033[38;2;205;214;244m'
        PEACH='\033[38;2;250;179;135m'
        DIM='\033[2m'
        BOLD='\033[1m'
        NC='\033[0m'

        echo ""
        echo -e "${LAVENDER}╭────────────────────────────────────────────────────────────╮${NC}"
        echo -e "${LAVENDER}│${NC}  ${BOLD}${BLUE}📖 Reina Valera 1960${NC} ${DIM}· Versículo de Bendición${NC}"
        echo -e "${LAVENDER}├────────────────────────────────────────────────────────────┤${NC}"

        if command -v fold &>/dev/null; then
            echo "$TEXT" | fold -s -w 58 | while IFS= read -r line; do
                printf "${LAVENDER}│${NC}  ${TEXT_COL}%-58s${NC}${LAVENDER}│${NC}\n" "$line"
            done
        else
            printf "${LAVENDER}│${NC}  ${TEXT_COL}%-58s${NC}${LAVENDER}│${NC}\n" "$TEXT"
        fi

        echo -e "${LAVENDER}│${NC}                                                            ${LAVENDER}│${NC}"
        printf "${LAVENDER}│${NC}  ${PEACH}%58s${NC}${LAVENDER}│${NC}\n" "— $REF"
        echo -e "${LAVENDER}╰────────────────────────────────────────────────────────────╯${NC}"
        echo ""
        ;;
esac
