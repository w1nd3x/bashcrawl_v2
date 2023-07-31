    grep
	find
	wc
	history
	sort
	uniq
	head
	tail
	tr
	cut
	sed
	awk
	
use find to locate an item
ls | grep "word" | wc -l
contemplate
	once finished with all the tasks print congrats message
Village
	farmer
		find => wc
		output to file
	shepherd
		ls | grep "word" or find
		output to file
		ls | grep "word" | wc -l
		read in from file output to file
Town
	blacksmith
		Was robbed! He can't find his prized anvil
		Once you find his anvil, he has you look to see if
		he has enough coal to light a fire. If you do, you have to 
		use head to redirect enough lines of 'high quality' coal into the 'forge' file
		head / tail
		uniq
	carpenter
		At first, he seems like a harmless person, but upon getting the confession from the 
		police station, you find that the carpenter was in cahoots with the criminal the 
		whole time! after that, he gives you the ledger of all the active jobs he has, 
		but they're super disorganized and he has duplicate jobs. He says that he'll turn in
		the anvil when you can sort his jobs. He even thinks he has some duplicate ones!
		sort
		head / tail
		uniq
	sheriff
		Talk to him first in the PoliceStation. Once you do, the three suspects are generated,
		and talking to them to get their precise statements will require use of head (head-case henry),
		tail (tail-bone terry), and sort/uniq (sort-a uniq-ue sam)
City
	carpenter's customer
	banker
		when you talk to him at first, he just wants you to open an account
		when you go back to get the money to buy the network company, however, he says he'll let
		you take out an exclusive interest free loan if you can give him the total number of money contained within his loans
		awk '{ sum += $1 } END { print sum }' file
		cut 
	network company
		going out of business
		tr ? 

use wc to count the number of files in a directory
