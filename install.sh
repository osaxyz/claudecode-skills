#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/osaxyz/claudecode-skills"
BRANCH="main"
TARBALL_URL="${REPO_URL}/archive/refs/heads/${BRANCH}.tar.gz"
TMP_DIR="$(mktemp -d)"
SKILL_DIR="commands"

cleanup() {
    printf '\e[?25h' > /dev/tty 2>/dev/null || true
    rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

echo "[osa.xyz] OSA Claude Code Skills — Installer"
echo ""

# ------------------------------------
# 1. インストール先の選択 (矢印キー対応)
# ------------------------------------
select_option() {
    local options=("$@")
    local count=${#options[@]}
    local selected=0

    # カーソルを非表示
    printf '\e[?25l' > /dev/tty

    # 選択肢を描画
    draw_menu() {
        local i
        for ((i = 0; i < count; i++)); do
            if [ $i -eq $selected ]; then
                printf '\r\e[K  \e[1;36m❯ %s\e[0m\n' "${options[$i]}" > /dev/tty
            else
                printf '\r\e[K    %s\n' "${options[$i]}" > /dev/tty
            fi
        done
    }

    # 初回描画
    draw_menu

    # キー入力ループ
    while true; do
        read -rsn1 key < /dev/tty
        case "$key" in
            $'\x1b')  # エスケープシーケンス (矢印キー)
                read -rsn2 rest < /dev/tty
                case "$rest" in
                    '[A')  # ↑
                        ((selected > 0)) && ((selected--))
                        ;;
                    '[B')  # ↓
                        ((selected < count - 1)) && ((selected++))
                        ;;
                esac
                ;;
            'k')  # vim: 上
                ((selected > 0)) && ((selected--))
                ;;
            'j')  # vim: 下
                ((selected < count - 1)) && ((selected++))
                ;;
            '')  # Enter
                break
                ;;
        esac
        # メニューを再描画 (カーソルを上に戻す)
        printf '\e[%dA' "$count" > /dev/tty
        draw_menu
    done

    # カーソルを再表示
    printf '\e[?25h' > /dev/tty

    return $selected
}

echo "インストール先を選択してください (↑↓/jk で移動, Enter で決定):"
echo ""

select_option \
    "このリポジトリ直下 (.claude/commands/)" \
    "ユーザーホーム (~/.claude/commands/)"
choice=$?

case "${choice}" in
    0)
        INSTALL_DIR="$(pwd)/.claude/commands"
        ;;
    1)
        INSTALL_DIR="${HOME}/.claude/commands"
        ;;
esac

echo ""
echo "インストール先: ${INSTALL_DIR}"
echo ""

# ------------------------------------
# 2. 最新版のダウンロード
# ------------------------------------
echo "最新版をダウンロード中..."
curl -fsSL "${TARBALL_URL}" -o "${TMP_DIR}/skills.tar.gz"
tar -xzf "${TMP_DIR}/skills.tar.gz" -C "${TMP_DIR}" --strip-components=1

# ------------------------------------
# 3. バージョン比較
# ------------------------------------
REMOTE_VERSION_FILE="${TMP_DIR}/VERSION"
VERSION_DIR="${INSTALL_DIR}/../osa"
LOCAL_VERSION_FILE="${VERSION_DIR}/VERSION"

remote_version="unknown"
local_version="none"

if [ -f "${REMOTE_VERSION_FILE}" ]; then
    remote_version="$(cat "${REMOTE_VERSION_FILE}")"
fi

if [ -f "${LOCAL_VERSION_FILE}" ]; then
    local_version="$(cat "${LOCAL_VERSION_FILE}")"
fi

if [ "${remote_version}" = "${local_version}" ]; then
    echo "すでに最新バージョン (${local_version}) です。アップデートは不要です。"
    exit 0
fi

echo "ローカル: ${local_version}"
echo "リモート: ${remote_version}"
echo ""

# ------------------------------------
# 4. インストール
# ------------------------------------
mkdir -p "${INSTALL_DIR}"

if [ -d "${TMP_DIR}/${SKILL_DIR}" ]; then
    cp -R "${TMP_DIR}/${SKILL_DIR}/"* "${INSTALL_DIR}/"
    echo "スキルファイルをインストールしました。"
else
    echo "警告: リポジトリに ${SKILL_DIR}/ ディレクトリが見つかりません。"
    echo "リポジトリ直下のファイルをコピーします。"
    cp -R "${TMP_DIR}/"*.md "${INSTALL_DIR}/" 2>/dev/null || true
fi

# VERSION ファイルをコピー
if [ -f "${REMOTE_VERSION_FILE}" ]; then
    mkdir -p "${VERSION_DIR}"
    cp "${REMOTE_VERSION_FILE}" "${LOCAL_VERSION_FILE}"
fi

echo ""
echo "[osa.xyz] インストール完了 (${remote_version})"
