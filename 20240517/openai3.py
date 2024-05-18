import tkinter as tk
import time

class FadeTicker(tk.Toplevel):
    def __init__(self, text_list, width=1600, height=100, font=("Helvetica", 32), *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        self.text_list = text_list
        self.current_index = 0
        self.width = width
        self.height = height
        self.font = font

        # Remove window decorations
        self.overrideredirect(1)
        
        # Set window size and position
        self.geometry(f"{self.width}x{self.height}+100+100")

        # Set background color to black
        self.configure(bg='black')
        
        self.label = tk.Label(self, text=self.text_list[self.current_index], font=self.font, fg='white', bg='black')
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
        self.current_index = (self.current_index + 1) % len(self.text_list)
        self.label.config(text=self.text_list[self.current_index])
        self.after(2000, self.fade_in)

    def _color(self, alpha):
        gray_value = int(255 * alpha)
        color = f'#{gray_value:02x}{gray_value:02x}{gray_value:02x}'
        return color

if __name__ == "__main__":
    text_list = ["Fading Ticker Text 1", "Fading Ticker Text 2", "Fading Ticker Text 3"]
    root = tk.Tk()
    root.withdraw()  # Hide the root window

    app = FadeTicker(text_list)
    app.title("Fade Ticker")
    app.mainloop()
