# -*- coding: utf-8 -*-
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch
import matplotlib.patheffects as pe

plt.rcParams['font.family'] = 'Tahoma'

fig, ax = plt.subplots(figsize=(24, 50))
ax.set_xlim(0, 24)
ax.set_ylim(0, 50)
ax.axis('off')
fig.patch.set_facecolor('#0f1117')
ax.set_facecolor('#0f1117')

C_START    = '#4ade80'
C_SCENE    = '#60a5fa'
C_SYSTEM   = '#a78bfa'
C_ACTION   = '#fbbf24'
C_DECISION = '#f87171'
C_LOOP     = '#34d399'
C_GREY     = '#94a3b8'
DARK       = '#0f1117'
LIGHT      = '#f1f5f9'

def box(ax, x, y, w, h, text, color, fs=9.5, tc=DARK):
    ax.add_patch(FancyBboxPatch(
        (x - w/2, y - h/2), w, h,
        boxstyle="round,pad=0.08,rounding_size=0.2",
        facecolor=color, edgecolor='white', linewidth=1.3, zorder=3))
    ax.text(x, y, text, ha='center', va='center', fontsize=fs,
            color=tc, fontweight='bold', zorder=4, multialignment='center')

def diamond(ax, x, y, w, h, text, color=C_DECISION, fs=9):
    pts = [(x, y+h/2), (x+w/2, y), (x, y-h/2), (x-w/2, y)]
    ax.add_patch(plt.Polygon(pts, closed=True,
                             facecolor=color, edgecolor='white', linewidth=1.3, zorder=3))
    ax.text(x, y, text, ha='center', va='center', fontsize=fs,
            color=DARK, fontweight='bold', zorder=4, multialignment='center')

def arr(ax, x1, y1, x2, y2, label='', lc='white', lw=1.6, rad=0.0):
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle='->', color=lc, lw=lw,
                                connectionstyle=f'arc3,rad={rad}'), zorder=2)
    if label:
        mx, my = (x1+x2)/2+0.12, (y1+y2)/2
        ax.text(mx, my, label, fontsize=8.5, color='#fde68a', fontweight='bold', zorder=5)

def lbl(ax, x, y, text, fs=8, color=C_GREY, italic=False):
    ax.text(x, y, text, fontsize=fs, color=color,
            fontstyle='italic' if italic else 'normal', zorder=5)

CX = 11


# ── SECTION BACKGROUNDS ─────────────────────────────────────────────────────
ax.add_patch(FancyBboxPatch((0.2, 37.1), 23.6, 10.5,
    boxstyle="round,pad=0.1", facecolor='#1e293b', edgecolor='#334155', lw=1, zorder=0))
ax.text(0.5, 47.4, 'เริ่มเกม', fontsize=8, color='#64748b', fontstyle='italic')

ax.add_patch(FancyBboxPatch((0.2, 11.5), 23.6, 25.4,
    boxstyle="round,pad=0.1", facecolor='#1a1f2e', edgecolor='#334155', lw=1, zorder=0))
ax.text(0.5, 36.7, 'Game Loop ── ทุก Physics Frame', fontsize=8, color='#64748b', fontstyle='italic')

ax.add_patch(FancyBboxPatch((0.2, 1.2), 23.6, 10.1,
    boxstyle="round,pad=0.1", facecolor='#1e1a2e', edgecolor='#334155', lw=1, zorder=0))
ax.text(0.5, 11.1, 'สิ้นสุด Wave / เกม', fontsize=8, color='#64748b', fontstyle='italic')

# ════════════════════════════════════════════════════════════════════════════
# NODES
# ════════════════════════════════════════════════════════════════════════════

# [1] START
box(ax, CX, 48.0, 5, 0.75, 'เปิดเกม', C_START, fs=13)

# [2] CHAR SELECT
box(ax, CX, 46.5, 6, 0.85,
    'หน้าเลือกตัวละคร\nCharacterSelect.gd', C_SCENE, fs=10)

# [3] DIFFICULTY
box(ax, CX, 45.0, 7, 0.85,
    'เลือกความยาก\nEasy x0.65  |  Normal x1.0  |  Hard x1.6', C_SYSTEM, fs=9.5, tc=LIGHT)

# [4] PLAY
box(ax, CX, 43.5, 5, 0.7,
    'กด Play  ->  โหลด game.tscn', C_ACTION, fs=10)

# [5] SPAWN PLAYER
box(ax, CX, 42.0, 7.5, 0.9,
    'Game._ready()\nGameManager.get_character_scene()\nสร้าง Player ที่ตำแหน่ง (0, 0)', C_SCENE, fs=9.5)

# [6] WAIT 1s
box(ax, CX, 40.6, 4, 0.65, 'รอ 1 วินาที', C_GREY, fs=10)

# [7] START WAVE
box(ax, CX, 39.3, 6.5, 0.8,
    'WaveManager.start_next_wave()\nwave += 1  |  คำนวณจำนวนศัตรู', C_SYSTEM, fs=9.5, tc=LIGHT)

# [8] DIAMOND wave > 20?
diamond(ax, CX, 37.8, 4.5, 1.1, 'wave > 20?')

# [9] DIAMOND wave % 5 == 0?
diamond(ax, CX, 36.0, 5.2, 1.1, 'wave หาร 5\nลงตัวไหม?')

# [10] SPAWN BOSS
box(ax, 19.0, 36.0, 5.5, 0.9,
    'Spawn Boss\nHP 600  DMG 25  XP 200\nวางที่ขอบ Arena', C_DECISION, fs=9, tc=DARK)

# [11] SPAWN ENEMIES
box(ax, CX, 34.2, 7, 1.0,
    'Spawn OrcBasic / OrcFast\nจำนวน = base x 1.3^(wave-1) x ตัวคูณ\nวางที่ขอบ Arena สุ่ม 4 ทิศ', C_ACTION, fs=9.5)

# ── 3 PARALLEL GAME-LOOP BOXES ──────────────────────────────────────────────
# [12] PLAYER MOVE
box(ax, 4.5, 32.4, 5.5, 0.9,
    'ผู้เล่นกด WASD\nเคลื่อนที่ด้วย move_and_slide()\nพลิก sprite ตามทิศ', C_LOOP, fs=9)

# [13] AUTO WEAPON
box(ax, CX, 32.4, 5.5, 0.9,
    'Weapon.fire() อัตโนมัติ\nหาศัตรูใกล้สุด\nยิงตาม fire_rate', C_LOOP, fs=9)

# [14] ENEMY AI
box(ax, 19.0, 32.4, 5.5, 0.9,
    'ศัตรูเดินหาผู้เล่น\nvelocity = direction x speed\nชนดีลดาเมจทุก cooldown', C_LOOP, fs=9)

# [15] DIAMOND arrow hit enemy?
diamond(ax, 7.5, 30.5, 4.8, 1.1, 'ลูกศรโดน\nศัตรูไหม?')

# [16] DIAMOND enemy hit player?
diamond(ax, 16.0, 30.5, 4.8, 1.1, 'ศัตรูชน\nผู้เล่นไหม?')

# [17] ENEMY TAKE DMG
box(ax, 7.5, 28.8, 5.5, 0.9,
    'ศัตรูรับดาเมจ\nHP -= (damage - armor)\narrow_pierce ทะลุศัตรูเพิ่ม', C_ACTION, fs=9)

# [18] DIAMOND invincible?
diamond(ax, 16.0, 28.8, 4.5, 1.0, 'กำลัง\nInvincible?')

# [19] PLAYER TAKE DMG
box(ax, 16.0, 27.1, 5.5, 1.0,
    'ผู้เล่นรับดาเมจ\nHP -= (damage - armor)\nเริ่ม Invincible 0.8 วิ\nโอกาส Dodge ด้วย dodge_chance', C_ACTION, fs=9)

# [20] DIAMOND enemy dead?
diamond(ax, 7.5, 25.6, 4.5, 1.0, 'ศัตรู HP = 0?')

# [21] DIAMOND player dead?
diamond(ax, 16.0, 25.3, 4.5, 1.0, 'ผู้เล่น HP = 0?')

# [22] ENEMY DIE
box(ax, 4.0, 23.8, 5.0, 0.9,
    'ศัตรูตาย\nหล่น XP\nenemies_alive -= 1', C_GREY, fs=9)

# [23] PLAYER DIE
box(ax, 19.5, 23.8, 5.0, 0.8,
    'ผู้เล่นตาย\nend_game(false)\ngame_over signal', C_GREY, fs=9)

# [24] GAIN XP
box(ax, 4.0, 22.5, 5.0, 0.7,
    'ผู้เล่นได้รับ XP\ncurrent_xp += xp_value', C_ACTION, fs=9)

# [25] DIAMOND level up?
diamond(ax, 4.0, 21.1, 4.5, 1.1, 'XP ครบ\nLevel ถัดไป?')

# [26] LEVEL UP
box(ax, 4.0, 19.5, 5.5, 0.9,
    'Level Up!\nlevel += 1\nคำนวณ xp_to_next ใหม่\nส่ง signal level_up', C_SYSTEM, fs=9, tc=LIGHT)

# [27] UPGRADE UI
box(ax, 4.0, 18.0, 5.8, 0.9,
    'UpgradeUI.show_upgrade()\nเกม Pause\nสุ่ม 3 อัปเกรดจาก 9 ตัวเลือก', C_SCENE, fs=9)

# [28] UPGRADE OPTIONS
box(ax, 4.0, 16.3, 6.5, 1.3,
    '+1 ลูกศร  |  Pierce  |  +fire rate\n+arrow speed  |  +15 DMG  |  +20 HP\n+2 Armor  |  +speed  |  +5% Dodge',
    C_ACTION, fs=9)

# [29] APPLY
box(ax, 4.0, 14.9, 5.5, 0.7,
    'เลือก Upgrade  ->  apply ค่า  ->  Unpause', C_LOOP, fs=9)

# [30] DIAMOND all enemies dead?
diamond(ax, CX, 13.5, 5.5, 1.1, 'enemies_alive = 0?')

# ── END SECTION ─────────────────────────────────────────────────────────────

# [31] WAIT 1.5s
box(ax, CX, 10.5, 4, 0.7, 'รอ 1.5 วินาที', C_GREY, fs=10)

# [32] DIAMOND all 20 waves?
diamond(ax, CX, 9.1, 5.5, 1.1, 'ผ่านครบ 20 Wave?')

# [33] WIN
box(ax, 18.5, 9.1, 5.5, 0.85,
    'ชนะเกม!\nend_game(true)\ngame_won signal', C_START, fs=10)

# [34] GAME OVER WAIT
box(ax, 19.5, 22.5, 4.5, 0.65, 'รอ 1.5 วินาที', C_GREY, fs=9.5)

# [35] WIN WAIT
box(ax, 18.5, 7.8, 4.5, 0.65, 'รอ 2 วินาที', C_GREY, fs=9.5)

# [36] RETURN (lose)
box(ax, 19.5, 21.2, 5, 0.75,
    'กลับหน้า CharacterSelect\n(change_scene_to_file)', C_SCENE, fs=9)

# [37] RETURN (win)
box(ax, 18.5, 6.6, 5, 0.75,
    'กลับหน้า CharacterSelect\n(change_scene_to_file)', C_SCENE, fs=9)

# ════════════════════════════════════════════════════════════════════════════
# ARROWS
# ════════════════════════════════════════════════════════════════════════════

arr(ax, CX, 47.62, CX, 46.92)           # START -> CHARSELECT
arr(ax, CX, 46.07, CX, 45.42)           # CHARSELECT -> DIFF
arr(ax, CX, 44.57, CX, 43.85)           # DIFF -> PLAY
arr(ax, CX, 43.15, CX, 42.45)           # PLAY -> SPAWN PLAYER
arr(ax, CX, 41.55, CX, 40.92)           # SPAWN -> WAIT1
arr(ax, CX, 40.27, CX, 39.7)            # WAIT1 -> START WAVE
arr(ax, CX, 38.9,  CX, 38.35)           # START WAVE -> D wave>20

# D wave>20: YES  -> jump to WIN (far right curve)
ax.annotate('', xy=(15.75, 9.1), xytext=(CX+2.25, 37.8),
            arrowprops=dict(arrowstyle='->', color='white', lw=1.6,
                            connectionstyle='arc3,rad=-0.25'), zorder=2)
lbl(ax, 14.3, 37.95, 'ใช่ -> ชนะ!', fs=8.5, color='#fde68a')

# D wave>20: NO -> D wave%5
arr(ax, CX, 37.25, CX, 36.55, 'ไม่')

# D wave%5: YES -> BOSS
arr(ax, CX+2.6, 36.0, 16.25, 36.0, 'ใช่')
# BOSS -> down then to SPAWN ENEMIES
arr(ax, 19.0, 35.55, 19.0, 34.7)
ax.annotate('', xy=(CX+3.5, 34.2), xytext=(19.0, 34.2),
            arrowprops=dict(arrowstyle='->', color='white', lw=1.6), zorder=2)

# D wave%5: NO -> SPAWN ENEMIES
arr(ax, CX, 35.45, CX, 34.7, 'ไม่')

# SPAWN -> 3 parallel boxes
arr(ax, CX-5, 34.2, 4.5, 32.85)
arr(ax, CX,   33.7, CX, 32.85)
arr(ax, CX+5, 34.2, 19.0, 32.85)

# PLAYER+WEAPON -> D arrow hit?
arr(ax, 5.5, 31.95, 6.8, 31.05)
arr(ax, CX-1.5, 31.95, 8.2, 31.05)

# ENEMY+WEAPON -> D enemy hit player?
arr(ax, 19.0, 31.95, 17.3, 31.05)
arr(ax, CX+1.5, 31.95, 15.4, 31.05)

# D arrow hit? YES -> ENEMY TAKE DMG
arr(ax, 7.5, 29.95, 7.5, 29.25, 'ใช่')
lbl(ax, 4.4, 30.1, 'ไม่ -> วนต่อ', fs=8, color=C_GREY)

# D enemy hit player? YES -> D INVINCIBLE
arr(ax, 16.0, 29.95, 16.0, 29.3, 'ใช่')
lbl(ax, 17.5, 30.2, 'ไม่ -> วนต่อ', fs=8, color=C_GREY)

# ENEMY TAKE DMG -> D enemy dead?
arr(ax, 7.5, 28.35, 7.5, 26.1)

# D INVINCIBLE: YES -> skip (label only)
lbl(ax, 17.8, 28.35, 'ใช่ -> วนต่อ', fs=8, color=C_GREY)
# D INVINCIBLE: NO -> PLAYER TAKE DMG
arr(ax, 16.0, 28.3, 16.0, 27.6, 'ไม่')

# PLAYER TAKE DMG -> D player dead?
arr(ax, 16.0, 26.6, 16.0, 25.8)

# D enemy dead? YES -> ENEMY DIE
arr(ax, 6.25, 25.6, 5.2, 24.25, 'ใช่')
lbl(ax, 7.8, 24.7, 'ไม่ -> วนต่อ', fs=8, color=C_GREY)

# D player dead? YES -> PLAYER DIE
arr(ax, 17.3, 25.3, 18.5, 24.2, 'ใช่')
lbl(ax, 12.5, 24.8, 'ไม่ -> วนต่อ', fs=8, color=C_GREY)

# ENEMY DIE -> GAIN XP
arr(ax, 4.0, 23.35, 4.0, 22.85)

# GAIN XP -> D level up?
arr(ax, 4.0, 22.15, 4.0, 21.65)

# D level up? YES -> LEVEL UP
arr(ax, 4.0, 20.55, 4.0, 19.95, 'ใช่')

# D level up? NO -> D all enemies dead? (right arc)
ax.annotate('', xy=(CX-2.75, 13.5), xytext=(4.0+2.25, 21.1),
            arrowprops=dict(arrowstyle='->', color='white', lw=1.6,
                            connectionstyle='arc3,rad=0.4'), zorder=2)
lbl(ax, 7.3, 18.5, 'ไม่', fs=8.5, color='#fde68a')

# LEVEL UP -> UPGRADE UI
arr(ax, 4.0, 19.05, 4.0, 18.45)
# UPGRADE UI -> OPTIONS
arr(ax, 4.0, 17.55, 4.0, 16.95)
# OPTIONS -> APPLY
arr(ax, 4.0, 15.65, 4.0, 15.25)
# APPLY -> D all enemies dead?
ax.annotate('', xy=(CX-2.75, 13.5), xytext=(4.0+2.75, 14.9),
            arrowprops=dict(arrowstyle='->', color='white', lw=1.6,
                            connectionstyle='arc3,rad=0.0'), zorder=2)

# D all enemies dead? YES -> WAIT 1.5
arr(ax, CX, 12.95, CX, 10.85, 'ใช่')
lbl(ax, 12.8, 12.5, 'ไม่ -> วนเกม', fs=8, color=C_GREY)

# WAIT 1.5 -> D all 20 waves?
arr(ax, CX, 10.15, CX, 9.65)

# D all 20 waves? YES -> WIN
arr(ax, CX+2.75, 9.1, 15.75, 9.1, 'ใช่')

# D all 20 waves? NO -> back to START WAVE (green loop line on left)
ax.annotate('', xy=(CX-3.25, 39.3), xytext=(CX-3.25, 9.1),
            arrowprops=dict(arrowstyle='->', color='#4ade80', lw=2.2,
                            connectionstyle='arc3,rad=0.0'), zorder=2)
lbl(ax, 0.3, 24.5, '< ไม่ -> Wave ถัดไป', fs=8.5, color='#4ade80')

# WIN -> WIN WAIT -> RETURN WIN
arr(ax, 18.5, 8.67, 18.5, 8.12)
arr(ax, 18.5, 7.47, 18.5, 6.97)

# RETURN WIN -> CHARSELECT (curved back up right side)
ax.annotate('', xy=(CX+3.0, 46.5), xytext=(18.5+2.5, 6.6),
            arrowprops=dict(arrowstyle='->', color='#4ade80', lw=2.0,
                            connectionstyle='arc3,rad=-0.35'), zorder=2)
lbl(ax, 22.0, 28.0, 'WIN', fs=9, color='#4ade80')

# PLAYER DIE -> GAME OVER WAIT -> RETURN LOSE
arr(ax, 19.5, 23.4, 19.5, 22.82)
arr(ax, 19.5, 22.17, 19.5, 21.57)

# RETURN LOSE -> CHARSELECT
ax.annotate('', xy=(CX+3.0, 46.5), xytext=(19.5+2.5, 21.2),
            arrowprops=dict(arrowstyle='->', color='#f87171', lw=2.0,
                            connectionstyle='arc3,rad=-0.25'), zorder=2)
lbl(ax, 22.8, 35.0, 'LOSE', fs=9, color='#f87171')

# ── Loop label ───────────────────────────────────────────────────────────────
lbl(ax, CX-0.5, 31.6, '<-- ซ้ำทุก frame -->', fs=8.5, color='#34d399', italic=True)

# ════════════════════════════════════════════════════════════════════════════
# LEGEND
# ════════════════════════════════════════════════════════════════════════════
lx, ly = 0.4, 5.5
ax.text(lx, ly+0.5, 'คำอธิบายสี', fontsize=9.5, color='white', fontweight='bold')
legend_items = [
    (C_START,    'เริ่ม / จบ / ชนะ'),
    (C_SCENE,    'หน้าจอ / Scene'),
    (C_SYSTEM,   'ระบบ / Manager'),
    (C_ACTION,   'Action / Event'),
    (C_DECISION, 'เงื่อนไข (Diamond)'),
    (C_LOOP,     'Game Loop'),
    (C_GREY,     'รอ / สิ้นสุด'),
]
for i, (c, label) in enumerate(legend_items):
    yy = ly - i * 0.6
    ax.add_patch(FancyBboxPatch(
        (lx, yy - 0.2), 0.6, 0.4,
        boxstyle="round,pad=0.04",
        facecolor=c, edgecolor='white', linewidth=0.9, zorder=3))
    ax.text(lx + 0.78, yy, label, fontsize=9, color='white', va='center')

plt.tight_layout(pad=0.5)
out = r'C:\Users\patga\Pat\broootatoo\game_flowchart.png'
plt.savefig(out, dpi=150, bbox_inches='tight', facecolor=fig.get_facecolor())
print('Saved: ' + out)
