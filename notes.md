.move(X, Y, Width, Height)
.setFont(, "Fontname")

FileOpen 

r = read
a = append 
w = write (overwrite)

file := FileOpen("test.txt", "w")
file.WriteLine("New content")
file.Close()