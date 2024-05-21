import tkinter as tk

arr = list(range(20));

i=0;

print(arr);

root = tk.Tk()
root.geometry("1600x100+0+100")
root.overrideredirect(True)

root.label = tk.Label(text="Hello")
root.label.pack()

def update_label():
    global arr, i
    root.label.config(text=str(arr[i]))
    i = i+1;
    root.after(1000, update_label)

root.after(1000, update_label)

root.mainloop()

# for i in range(100000):
#    root.label.config(text=str(i))


