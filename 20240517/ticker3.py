import tkinter as tk
import datetime
import pytz

tzone = pytz.timezone("EST5EDT");
print(datetime.datetime.now().astimezone(tzone).strftime("%H%M,%a%d%b"))


exit();

# arr = list(range(20));

arr = [];

i=0;

zones = {
          "ASamoa": "Pacific/Pago_Pago",
          "HST": "Pacific/Honolulu",
          "PT": "US/Pacific",
          "MT":  "US/Mountain",
          "CT": "US/Central",
          "ET": "US/Eastern",
          "GMT": "GMT",
          "Lagos": "Africa/Lagos",
          "Milan": "Europe/Rome", 
          "Cairo": "Africa/Cairo",
          "Delhi": "Asia/Kolkata",
          "Jakarta": "Asia/Jakarta",
          "HongKong": "Asia/Hong_Kong", 
          "Manila": "Asia/Manila",
          "Tokyo": "Asia/Tokyo",
          "Brisbane": "Australia/Brisbane",
          "Sydney": "Australia/Sydney",
          "Auckland": "Pacific/Auckland",
          "Chatam":"Pacific/Chatham",
          "Samoa": "Pacific/Apia"
}

for i in zones:
    
    current_time = datetime.datetime.now(datetime.timezone.utc).astimezone(zones[i])
    tz = pytz.timezone(zones[i])
    print(current_time.strftime("%H%M,%a%d%b"))

#    zstr = zones[i]+ " "+
#    print(i, zones[i])

exit()

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


