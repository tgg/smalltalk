"======================================================================
|
| Copyright 2006 Mike Anderson
| Written by Mike Anderson
|
| This is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 2, or (at your option) any later version.
| 
| This code is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| Mumble; see the file COPYING.  If not, write to the Free Software
| Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  
|
 ======================================================================
"



Object subclass: Connection [
    
    <category: 'DBI-Framework'>
    <comment: 'I represent a connection to a database.'>

    Drivers := LookupTable new.

    Connection class >> updateDriverList [
	"Private - Look for new subclasses of Connection."
	<category: 'initialization'>
	Drivers := LookupTable new.
	Connection allSubclassesDo: [ :each |
	    each driverName isNil ifFalse: [
		Drivers at: each driverName put: each ] ]
    ]

    Connection class >> driverName [
	"Override this method, returning the name of the driver, in every
	 concrete subclass of Connection.  Abstract classes should return
	 nil instead."
	^nil
    ]

    Connection class >> paramConnect: params user: aUserName password: aPassword [
	"Connect to the database server using the parameters in params (a
	Dictionary) and the given username and password (abstract)."

	<category: 'connecting'>
	self subclassResponsibility
    ]

    Connection class >> connect: aDSN user: aUserName password: aPassword [
	"Connect to the database server identified by aDSN using the given
	 username and password.  The DSN is in the format
	 dbi:DriverName:dbname=database_name;host=hostname;port=port
	 Where dbi is constant, DriverName is the name of the driver, and
	 everything else is parameters in the form name1=value1;name2=value2;...
	 
	 Individual drivers may parse the parameters differently, though
	 the existing ones all support parameters dbname, host and port."

	<category: 'connecting'>
	| info driverClass driver |
	info := ConnectionInfo fromDSN: aDSN.
	info scheme asLowercase = 'dbi' 
	    ifFalse: [self error: 'Connection string is not for DBI!'].
	driver := info driver.
	driverClass := Drivers at: driver
		    ifAbsent: [self updateDriverList.
			Drivers at: driver
			    ifAbsent: [self error: 'Unknown driver: ' , driver]].
	^driverClass 
	    paramConnect: info params
	    user: aUserName
	    password: aPassword
    ]

    do: aSQLQuery [
	"Executes a SQL statement (usually one that doesn't return a result set).
	 Return value is a ResultSet, to which you can send #rowsAffected
	 (abstract)."

	<category: 'querying'>
	self subclassResponsibility
    ]

    prepare: aSQLQuery [
	"Creates a statement object, that can be executed (with parameters, if
	 applicable) repeatedly (abstract)."

	<category: 'querying'>
	self subclassResponsibility
    ]

    select: aSQLQuery [
	"Prepares and executes a SQL statement. Returns the result set or
	 throws an exception on failure (abstract)."

	<category: 'querying'>
	self subclassResponsibility
    ]

    close [
	"Close the connection now; should happen on GC too (abstract)."

	<category: 'connecting'>
	self subclassResponsibility
    ]
]



Eval [
    Connection initialize
]
