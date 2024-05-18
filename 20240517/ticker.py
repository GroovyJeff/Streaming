import tkinter as tk
import time

class FadeTicker(tk.Toplevel):
    def __init__(self, text, width=1600, height=50, font=("Helvetica", 32), *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        self.text = text
        self.width = width
        self.height = height
        self.font = font

        # Remove window decorations
        self.overrideredirect(1)
        
        # Set window size and position
        self.geometry(f"{self.width}x{self.height}+0+100")

        # Set background color to black
        self.configure(bg='white')
        
        self.label = tk.Label(self, text=self.text, font=self.font, fg='white', bg='black')
        self.label.pack(expand=True)

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
    root = tk.Tk()
    root.withdraw()  # Hide the root window

    app = FadeTicker(text)
    app.title("Fade Ticker")
    app.mainloop()
