#!/usr/bin/env python3
"""
Macro Recorder & Looper
========================
- Press F8  → Start recording mouse movements & clicks
- Press F9  → Stop recording
- Press F10 → Play recorded macro in a loop
- Press F11 → Stop playback
- Press ESC → Quit the program

Install dependencies:
    pip install pynput
"""

import time
import threading
from pynput import mouse, keyboard
from pynput.mouse import Button, Controller as MouseController
from pynput.keyboard import Key, Controller as KeyboardController

# ── State ──────────────────────────────────────────────────────────────────────
recording = False
playing = False
events = []          # list of (delay, type, data)
_last_time = None
_mouse_ctrl = MouseController()
_stop_playback = threading.Event()

# ── Helpers ────────────────────────────────────────────────────────────────────

def _timestamp():
    global _last_time
    now = time.time()
    delta = now - _last_time if _last_time else 0
    _last_time = now
    return delta


def start_recording():
    global recording, events, _last_time
    if recording:
        return
    events = []
    _last_time = time.time()
    recording = True
    print("\n🔴 Recording started — press F9 to stop.")


def stop_recording():
    global recording
    if not recording:
        return
    recording = False
    print(f"⏹  Recording stopped. {len(events)} events captured.")


def play_loop():
    global playing
    _stop_playback.clear()
    playing = True
    print("▶️  Playback started — press F11 to stop.")

    if not events:
        print("⚠️  No events recorded.")
        playing = False
        return

    try:
        while not _stop_playback.is_set():
            for delay, etype, data in events:
                if _stop_playback.is_set():
                    break
                # honour timing (capped at 2 s to keep loops snappy)
                time.sleep(min(delay, 2.0))
                if etype == "move":
                    _mouse_ctrl.position = data
                elif etype == "click":
                    x, y, btn, pressed = data
                    _mouse_ctrl.position = (x, y)
                    if pressed:
                        _mouse_ctrl.press(btn)
                    else:
                        _mouse_ctrl.release(btn)
                elif etype == "scroll":
                    x, y, dx, dy = data
                    _mouse_ctrl.position = (x, y)
                    _mouse_ctrl.scroll(dx, dy)
    finally:
        playing = False
        print("⏹  Playback stopped.")


def start_playback():
    if playing:
        print("Already playing.")
        return
    t = threading.Thread(target=play_loop, daemon=True)
    t.start()


def stop_playback():
    _stop_playback.set()


# ── Mouse listener callbacks ───────────────────────────────────────────────────

def on_move(x, y):
    if recording:
        events.append((_timestamp(), "move", (x, y)))


def on_click(x, y, button, pressed):
    if recording:
        events.append((_timestamp(), "click", (x, y, button, pressed)))


def on_scroll(x, y, dx, dy):
    if recording:
        events.append((_timestamp(), "scroll", (x, y, dx, dy)))


# ── Keyboard listener callback ─────────────────────────────────────────────────

def on_press(key):
    if key == Key.f8:
        start_recording()
    elif key == Key.f9:
        stop_recording()
    elif key == Key.f10:
        start_playback()
    elif key == Key.f11:
        stop_playback()
    elif key == Key.esc:
        stop_recording()
        stop_playback()
        print("👋 Exiting.")
        return False          # stops the keyboard listener → program ends


# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    print("=" * 50)
    print("  Macro Recorder & Looper")
    print("=" * 50)
    print("  F8  — Start recording")
    print("  F9  — Stop  recording")
    print("  F10 — Start playback loop")
    print("  F11 — Stop  playback loop")
    print("  ESC — Quit")
    print("=" * 50)

    mouse_listener = mouse.Listener(
        on_move=on_move,
        on_click=on_click,
        on_scroll=on_scroll,
    )
    mouse_listener.start()

    # keyboard.Listener blocks until it returns False (ESC pressed)
    with keyboard.Listener(on_press=on_press) as kb_listener:
        kb_listener.join()

    mouse_listener.stop()


if __name__ == "__main__":
    main()
