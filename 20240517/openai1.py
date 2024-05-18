import tkinter as tk
import time

class FadeTicker(tk.Tk):
    def __init__(self, text, font=("Helvetica", 32), *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        self.text = text
        self.font = font
        
        self.label = tk.Label(self, text=self.text, font=self.font)
        self.label.pack(pady=20)
        
        self.fade_in()

    def fade_in(self, step=0.05, delay=50):
        for i in range(101):
            alpha = i / 100
            self.label.config(fg=self._color(alpha))
            self.update()
            time.sleep(step)
        self.after(2000, self.fade_out)

    def fade_out(self, step=0.05, delay=50):
        for i in range(101):
            alpha = (100 - i) / 100
            self.label.config(fg=self._color(alpha))
            self.update()
            time.sleep(step)
        self.after(2000, self.fade_in)

    def _color(self, alpha):
        gray_value = int(255 * alpha)
        color = f'#{gray_value:02x}{gray_value:02x}{gray_value:02x}'
        return color

if __name__ == "__main__":
    text = "Fading Ticker Text"
    app = FadeTicker(text)
    app.title("Fade Ticker")
    app.geometry("400x200")
    app.mainloop()
