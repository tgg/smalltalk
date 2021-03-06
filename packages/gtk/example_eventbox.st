"======================================================================
|
|   Smalltalk Gtk+ bindings examples
|
 ======================================================================"

"======================================================================
|
| Copyright 2001, 2003, 2009 Free Software Foundation, Inc.
| Written by Paolo Bonzini.
|
| This file is part of the GNU Smalltalk class library.
|
| The GNU Smalltalk class library is free software; you can redistribute it
| and/or modify it under the terms of the GNU Lesser General Public License
| as published by the Free Software Foundation; either version 2.1, or (at
| your option) any later version.
| 
| The GNU Smalltalk class library is distributed in the hope that it will be
| useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
| General Public License for more details.
| 
| You should have received a copy of the GNU Lesser General Public License
| along with the GNU Smalltalk class library; see the file COPYING.LESSER.
| If not, write to the Free Software Foundation, 59 Temple Place - Suite
| 330, Boston, MA 02110-1301, USA.  
|
 ======================================================================"


PackageLoader fileInPackage: 'GTK'.


Namespace current: GTK [

Object subclass: EventBoxExample [
    
    <category: nil>
    <comment: nil>

    buttonPressEvent: object event: event data: data [
	<category: 'event handling'>
	data destroy
    ]

    destroy: object data: data [
	<category: 'event handling'>
	Gtk mainQuit
    ]

    open [
	<category: 'layout'>
	| window eventBox label |
	window := GtkWindow new: Gtk gtkWindowToplevel.
	window 
	    connectSignal: 'destroy'
	    to: self
	    selector: #destroy:data:
	    userData: nil.
	window setTitle: 'Event Box'.
	window setBorderWidth: 10.
	eventBox := GtkEventBox new.
	window add: eventBox.
	eventBox show.
	label := GtkLabel new: 'Click here to quit, quit, quit, quit, quit'.
	eventBox add: label.
	label show.
	label setSizeRequest: 110 height: 20.
	eventBox setEvents: Gdk gdkButtonPressMask.
	eventBox 
	    connectSignal: 'button_press_event'
	    to: self
	    selector: #buttonPressEvent:event:data:
	    userData: window.
	eventBox realize.
	eventBox getWindow setCursor: (GdkCursor new: Gdk gdkHand1).
	window show
    ]
]

]



Namespace current: GTK [
    EventBoxExample new open.
    Gtk main
]

