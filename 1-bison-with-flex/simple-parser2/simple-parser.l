/* Όνομα αρχείου:	simple-parser.l
   Περιγραφή:		Απλός λεκτικός αναλυτής - μέρος του αντίστοιχου συντακτικού αναλυτή
			(κώδικας για το εργαλείο Flex)
   Συγγραφέας:		Εργαστήριο Μεταγλωττιστών, Τμήμα Μηχ.Πληροφορικής ΤΕ, ΤΕΙ Αθήνας
   Σχόλια:		Το παρόν πρόγραμμα υλοποιεί (με τη χρήση Flex) έναν απλό λεκτικό
			αναλυτή που αναγνωρίζει:
				1) Tabs και κενά
				2) Αναγνωριστικά (identifiers - ονόματα μεταβλητών)
				3) Ακέραιους αριθμούς
				4) Τη λέξη "int"
				5) Τον χαρακτήρα ';'
				6) Τον χαρακτήρα '='
				7) Τον ειδικό χαρακτήρα '\n' - newline
			Σε οποιαδήποτε άλλη περίπτωση εκτυπώνει το μήνυμα "Token error"
*/

%option noyywrap

/* Κώδικας C για ορισμό των απαιτούμενων header files και των μεταβλητών.
   Οτιδήποτε ανάμεσα στα %{ και %} μεταφέρεται αυτούσιο στο αρχείο C που
   θα δημιουργήσει το Flex. */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file που περιέχει λίστα με όλα τα tokens */
#include "simple-parser.tab.h"

extern int flag;
extern int line;

void prn(char *s);

%}

/* Ονόματα και αντίστοιχοι ορισμοί (υπό μορφή κανονικής έκφρασης).
   Μετά από αυτό, μπορεί να γίνει χρήση των ονομάτων (αριστερά) αντί των,
   συνήθως ιδιαίτερα μακροσκελών και δυσνόητων, κανονικών εκφράσεων */

DELIMITERS [ \t]+
ID [A-Za-z][A-Za-z0-9]*(_[A-Za-z0-9]+)*
DIGIT_H [1-9]
DIGIT_L [0-9]


/* Για κάθε pattern (αριστερά) που ταιριάζει εκτελείται ο αντίστοιχος
   κώδικας μέσα στα άγκιστρα. Η εντολή return επιτρέπει την επιστροφή
   μιας συγκεκριμένης αριθμητικής τιμής που αντιπροσωπεύει τη λεκτική
   μονάδα που διαβάστηκε. Η τιμή αυτή χρησιμοποιείται από το εργαλείο
   Bison για τη συντακτική ανάλυση της εισόδου */

%%

"int"				{prn("INT"); return SINT;}
";"				{prn("SEMI"); return SEMI;}
"="				{prn("ASSIGNOP"); return ASSIGNOP;}
{DELIMITERS}			{ }
\n 				{line++; }
0|-?({DIGIT_H}+{DIGIT_L}*)+	{prn("INTCONST"); return INTCONST;}
{ID} 				{prn("IDENTIFIER"); return IDENTIFIER;}
. 				{printf("Token error\n");}

%%


/* Η συνάρτηση prn τυπώνει στην οθόνη τον τύπο του αναγνωριστικού (πχ. ASSIGNOP)
   που έγινε match καθώς και το ίδιο το κείμενο (πχ. =) του αναγνωριστικού. Ο
   λόγος ύπαρξής της είναι καθαρά για καλύτερη κατανόηση του κώδικα και για
   γενικότερη διευκόλυνση στο debugging της εφαρμογής */

void prn(char *s)
{
	printf("\n\t%s: %s ", s, yytext);
	return;
}