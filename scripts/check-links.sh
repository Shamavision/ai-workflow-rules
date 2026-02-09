#!/bin/bash
# scripts/check-links.sh - Check all markdown internal links
# Part of AI Workflow Rules Framework v9.1.1

echo "🔍 Checking all markdown links..."
echo ""

ERRORS=0
CHECKED=0

for file in $(find . -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/npm-templates/*"); do
  echo "Checking: $file"

  # Extract all local links [text](path.md) or [text](path/file.md)
  links=$(grep -o '\](.*\.md)' "$file" | tr -d '][' | tr -d '()' || true)

  if [ -n "$links" ]; then
    while IFS= read -r link; do
      # Skip external links (http/https)
      if [[ "$link" == http* ]]; then
        continue
      fi

      # Skip anchors only (#section)
      if [[ "$link" == \#* ]]; then
        continue
      fi

      # Resolve relative path
      dir=$(dirname "$file")

      # Remove anchor from link if present (file.md#section -> file.md)
      clean_link=$(echo "$link" | sed 's/#.*//')

      full_path="$dir/$clean_link"

      ((CHECKED++))

      if [ ! -f "$full_path" ]; then
        echo "  ✗ BROKEN: $link in $file"
        echo "    Expected: $full_path"
        ((ERRORS++))
      fi
    done <<< "$links"
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total links checked: $CHECKED"

if [ $ERRORS -eq 0 ]; then
  echo "✅ All links OK!"
  exit 0
else
  echo "❌ Found $ERRORS broken links"
  exit 1
fi
