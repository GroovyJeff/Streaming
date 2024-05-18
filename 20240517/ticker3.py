import tkinter as tk

root = tk.Tk()
root.geometry("1600x100+0+100")
root.overrideredirect(True)

root.label = tk.Label(text="Hello")
root.label.pack()

root.mainloop()

for i in range(100000):
    root.label.config(text=str(i))


