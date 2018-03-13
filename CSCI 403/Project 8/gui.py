#!/usr/bin/python3

from tkinter import *
from tkinter.ttk import *
from tkinter import messagebox
from tkinter import font
import pg8000

# implements a simple login window
class LoginWindow:
    def __init__(self, window):
        self.window = window

        self.window.title('Login')
        self.window.grid()

        # styling
        self.font = font.Font(family = 'Arial', size = 12)
        Style().configure('TButton', font = self.font)
        Style().configure('TLabel', font = self.font)

	# setup widgets
        self.user_label = Label(window, text='Username: ')
        self.user_label.grid(column = 0, row = 0)
        self.user_input = Entry(window, width = 20, font = self.font)
        self.user_input.grid(column = 1, row = 0)

        self.pw_label = Label(window, text='Password: ')
        self.pw_label.grid(column = 0, row = 1)
        self.pw_input = Entry(window, width = 20, show='*', font = self.font)
        self.pw_input.grid(column = 1, row = 1)

        self.button_frame = Frame(window)
        self.button_frame.grid(column = 0, columnspan = 2, row = 2)

        self.ok_button = Button(self.button_frame, text='OK', command=self.ok_action)
        self.ok_button.grid(column = 0, row = 0)

        self.cancel_button = Button(self.button_frame, text='Cancel', command=quit)
        self.cancel_button.grid(column = 1, row=0)

        self.window.bind('<Return>', self.enter_action)
        self.user_input.focus_set()

    def enter_action(self, event):
        self.ok_action()

    def ok_action(self):
        try:        
            credentials = {'user'     : self.user_input.get(),
                           'password' : self.pw_input.get(),
                           'database' : 'csci403',
                           'host'     : 'flowers.mines.edu' }
            self.db = pg8000.connect(**credentials)
            self.window.destroy()
        except pg8000.Error as e:
            messagebox.showerror('Login Failed', e.args[2])
# end LoginWindow


class Application:
    def __init__(self, window, db):
        self.window = window
        self.window.title('CSCI 403 Example')
        self.window.grid()

        self.db = db
        self.cursor = db.cursor()
        
        # styling
        self.font = font.Font(family = 'Arial', size = 12)
        Style().configure('TButton', font = self.font)
        Style().configure('TLabel', font = self.font)

        # search portion of GUI
        self.search_frame = Frame(window);
        self.search_frame.grid(row = 0, column = 0)
        self.search_label = Label(self.search_frame, text = 'Search by: ')
        self.search_label.grid(row = 0, column = 0)
        self.search_cb = Combobox(self.search_frame, values = ('Artist','Album'), font = self.font)
        self.search_cb.grid(row = 0, column = 1)
        self.search_text = Entry(self.search_frame, width = 40, font = self.font)
        self.search_text.grid(row = 0, column = 2)
        self.search_button = Button(self.search_frame, text = 'Search', command = self.search_action)
        self.search_button.grid(row = 0, column = 3)

        # search results
        self.results_frame = Frame(window)
        self.results_frame.grid(row = 1, column = 0)
        self.results_sb = Scrollbar(self.results_frame)
        self.results_sb.pack(side = RIGHT, fill = Y)
        self.results_lb = Listbox(self.results_frame, height = 10, width = 80, font = self.font, exportselection = 0)
        self.results_lb.pack()
        self.results_lb.config(yscrollcommand = self.results_sb.set)
        self.results_sb.config(command = self.results_lb.yview)
        self.current_search_results = []

        # edit frame
        self.edit_frame = Frame(window)
        self.edit_frame.grid(row = 2, column = 0, padx = 10, pady = 10)
        
        # buttons
        self.button_frame = Frame(window)
        self.button_frame.grid(row = 3, column = 0)
        self.add_artist_button = Button(self.button_frame, text = 'Add Artist', command = self.show_add_artist)
        self.add_artist_button.grid(row = 0, column = 0)
        self.add_album_button = Button(self.button_frame, text = 'Add Album', command = self.show_add_album)
        self.add_album_button.grid(row = 0, column = 1)
        self.edit_album_button = Button(self.button_frame, text = 'Edit Album', command = self.show_edit_album, state = DISABLED)
        self.edit_album_button.grid(row = 0, column = 2)
        self.delete_album_button = Button(self.button_frame, text = 'Delete Album', command = self.remove_album, state = DISABLED)
        self.delete_album_button.grid(row = 0, column = 3)
        self.quit_button = Button(self.button_frame, text = 'Quit', command = self.window.destroy)
        self.quit_button.grid(row = 0, column = 4)

        # search results listbox callbacks
        self.results_lb.bind('<<ListboxSelect>>', self.album_select)

    def search_action(self):
        search_string = self.search_text.get()
        self.results_lb.delete(0, self.results_lb.size())
        self.edit_album_button.config(state = DISABLED)
        self.delete_album_button.config(state = DISABLED)
        if self.search_cb.get() == 'Artist':
            self.current_search_results = self.search_by_artist(search_string)
        elif self.search_cb.get() == 'Album':
            self.current_search_results = self.search_by_album(search_string)
        for artist, title, year, album_id in self.current_search_results:
            s = artist + ' - ' + title + ' (' + str(year) + ')'
            self.results_lb.insert(END, s)

    def album_select(self, event):
        if len(self.results_lb.curselection()):
            self.edit_album_button.config(state = NORMAL)
            self.delete_album_button.config(state = NORMAL)
        else:
            self.edit_album_button.config(state = DISABLED)
            self.delete_album_button.config(state = DISABLED)

    def recreate_edit_frame(self):
        self.edit_frame.destroy()
        self.edit_frame = Frame(window)
        self.edit_frame.grid(row = 2, column = 0, padx = 10, pady = 10)

    def show_add_artist(self):
        self.recreate_edit_frame()
        add_artist_label = Label(self.edit_frame, text = 'Add Artist')
        add_artist_label.grid(row = 0, columnspan = 3, column = 0)
        artist_entry_label = Label(self.edit_frame, text = 'New artist name: ')
        artist_entry_label.grid(row = 1, column = 0)
        self.add_artist_entry = Entry(self.edit_frame, width = 40, font = self.font)
        self.add_artist_entry.grid(row = 1, column = 1)
        save = Button(self.edit_frame, text = 'Save', command = self.save_new_artist)
        save.grid(row = 1, column = 2)

    def save_new_artist(self):
        if len(self.add_artist_entry.get()) == 0:
            messagebox.showerror('Error Saving Artist', 'Please enter an artist name.')
        else:
            self.insert_artist(self.add_artist_entry.get())
            self.recreate_edit_frame()

    def show_add_album(self):
        self.recreate_edit_frame()
        artist_list = self.get_artists()
        add_album_label = Label(self.edit_frame, text = 'Add Album')
        add_album_label.grid(row = 0, column = 0, columnspan = 2)
        artist_choose_label = Label(self.edit_frame, text = 'Choose artist: ')
        artist_choose_label.grid(row = 1, column = 0)
        self.artist_cb = Combobox(self.edit_frame, values = artist_list, font = self.font)
        self.artist_cb.grid(row = 1, column = 1)
        album_entry_label = Label(self.edit_frame, text = 'Enter album title: ')
        album_entry_label.grid(row = 2, column = 0)
        self.album_entry = Entry(self.edit_frame, width = 40, font = self.font)
        self.album_entry.grid(row = 2, column = 1)
        year_entry_label = Label(self.edit_frame, text = 'Enter album year: ')
        year_entry_label.grid(row = 3, column = 0)
        self.year_entry = Entry(self.edit_frame, width = 40, font = self.font)
        self.year_entry.grid(row = 3, column = 1)
        save = Button(self.edit_frame, text = 'Save', command = self.save_new_album)
        save.grid(row = 4, column = 0, columnspan = 2)

    def save_new_album(self):
        if len(self.artist_cb.get()) == 0:
            messagebox.showerror('Error Saving Album', 'Please select an artist.')
        elif len(self.album_entry.get()) == 0:
            messagebox.showerror('Error Saving Album', 'Please enter an album title.')
        else:
            self.insert_album(self.artist_cb.get(), self.album_entry.get(), self.year_entry.get())
            self.recreate_edit_frame()

    def show_edit_album(self):
        self.recreate_edit_frame()
        rows = self.results_lb.curselection()
        artist, album_title, year, album_id = self.current_search_results[rows[0]]
        edit_album_label = Label(self.edit_frame, text = 'Edit Album')
        edit_album_label.grid(row = 0, column = 0, columnspan = 2)
        artist_label = Label(self.edit_frame, text = 'Artist:')
        artist_label.grid(row = 1, column = 0)
        artist_entry = Entry(self.edit_frame, width = 40, font = self.font)
        artist_entry.insert(0, artist)
        artist_entry.config(state = DISABLED)
        artist_entry.grid(row = 1, column = 1)
        album_entry_label = Label(self.edit_frame, text = 'Album title: ')
        album_entry_label.grid(row = 2, column = 0)
        self.album_entry = Entry(self.edit_frame, width = 40, font = self.font)
        self.album_entry.insert(0, album_title)
        self.album_entry.grid(row = 2, column = 1)
        year_entry_label = Label(self.edit_frame, text = 'Album year: ')
        year_entry_label.grid(row = 3, column = 0)
        self.year_entry = Entry(self.edit_frame, width = 40, font = self.font)
        self.year_entry.insert(0, str(year))
        self.year_entry.grid(row = 3, column = 1)
        save = Button(self.edit_frame, text = 'Save', command = self.save_edited_album)
        save.grid(row = 4, column = 0, columnspan = 2)

    def save_edited_album(self):
        if len(self.album_entry.get()) == 0:
            messagebox.showerror('Error Saving Album', 'Please enter an album title.')
        else:
            rows = self.results_lb.curselection()
            artist, album_title, year, album_id = self.current_search_results[rows[0]]
            self.current_search_results[rows[0]][1] = self.album_entry.get()
            self.current_search_results[rows[0]][2] = self.year_entry.get()
            self.update_album(album_id, self.album_entry.get(), self.year_entry.get())
            self.results_lb.delete(rows[0], rows[0])
            s = artist + ' - ' + self.album_entry.get() + ' (' + str(self.year_entry.get()) + ')'
            self.results_lb.insert(rows[0], s)
            self.recreate_edit_frame()

    def remove_album(self):
        self.recreate_edit_frame()
        if messagebox.askyesno('Delete Confirmation', 'Are you sure?'):
            rows = self.results_lb.curselection()
            artist, album_title, year, album_id = self.current_search_results[rows[0]]
            self.delete_album(album_id)
            self.results_lb.delete(ANCHOR)
        

###################
# EDIT BELOW HERE #
###################

    def search_by_artist(self, search_string):
        query = """SELECT art.name, alb.title, alb.year, alb.id
                   FROM artist AS art, album AS alb
                   WHERE lower(art.name) LIKE lower(%s)
                   AND art.id = alb.artist_id
                   ORDER BY art.name, alb.year, alb.title"""

        search_string = '%' + search_string + '%'
        try:
            self.cursor.execute(query, (search_string, ))

            results = self.cursor.fetchall()
            return results

        except pg8000.Error as e:
            messagebox.showerror('Database error', e.args[2])
            return None

    def search_by_album(self, search_string):
        query = """SELECT art.name, alb.title, alb.year, alb.id
                   FROM artist AS art`, album AS alb
                   WHERE lower(art.name) LIKE lower(%s)
                   AND art.id = alb.artist_id
                   ORDER BY art.name, alb.year, alb.title"""

        search_string = '%' + search_string + '%'
        try:
            self.cursor.execute(query, (search_string, ))

            results = self.cursor.fetchall()
            return results

        except pg8000.Error as e:
            messagebox.showerror('Database error', e.args[2])
            return None
        return [['Search by album', search_string, '?', '(Not yet implemented)']]

    def insert_artist(self, artist_name):
        query = """ INSERT INTO artist (name) VALUES (%s) """
        search_string = artist_name
        try:
                self.cursor.execute(query, (search_string, ))
                self.db.commit()
        except pg8000.Error as e:
                messagebox.showerror('There has been an error', e.args[2])
        print('Save new artist: ' + artist_name + ' (Not yet implemented)')

    def get_artists(self):
        query = """ SELECT name FROM artist
                    ORDER BY name """
        try:
                self.cursor.execute(query)
                results = self.cursor.fetchall()
                results = [item for sublist in results for item in sublist]
                print(results)
                return results
        except pg8000.Error as e:
                messagebox.showerror('There has been an error', e.args[2])
                return None
        return ['Chris Thile', 'Hiromi', 'Jethro Tull']

    def insert_album(self, artist_name, album_name, year):
        query = """INSERT INTO album (artist_id, title, year)
                   VALUES ((SELECT id FROM artist WHERE name = %s), %s, %s); """
        try:
                self.cursor.execute(query, (artist_name, album_name, year))
                self.db.commit()
        except pg8000.Error as e:
                print('Insert album: ' + str(album_name) + "failed")
                print(e)
                return None
        print('Save new album: ' + artist_name + ' - ' + album_name + ' (' + year + ')' + ' (Not yet implemented)')

    def update_album(self, album_id, album_name, year):
        query = """UPDATE album SET (title, year) = (%s, %s) WHERE id = %s; """
        try:
                self.cursor.execute(query, (album_name, year, album_id))
                self.db.commit()
        except pg8000.Error as e:
                print('Update album: ' + str(album_name) + "failed")
                print(e)
                messagebox.showerror('There was an error', e.args[0])
                return None
        print('Update album: ' + str(album_id) + ': ' + album_name + ' (' + year + ')' + ' (Not yet implemented)')

    def delete_album(self, album_id):
        query = """DELETE FROM album WHERE id = %s """
        try:
                self.cursor.execute(query, (album_id, ))
                self.db.commit()
        except pg8000.Error as e:
                print('Delete album: ' + str(album_id) + "failed")
                print(e)
                return None
        print('Delete album: ' + str(album_id))
    
# end of Application


############################
# application startup code #
############################

lw = Tk()
lwapp = LoginWindow(lw)
lw.mainloop()

window = Tk()
app = Application(window, lwapp.db)
window.mainloop()


