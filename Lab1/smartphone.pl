/* SumSum, a competitor of Appy, developed some nice smart phone technology called
Galactica-S3, all of which was stolen by Stevey, who is a Boss. It is unethical
for a Boss to steal business from rival companies. A competitor of Appy is a rival.
Smart phone technology is a business */

/* 2. Write these FOL statements as Prolog clauses*/
company(sumsum).
company(appy).
tech(galactica-s3).
developed(galactica-s3,sumsum).
boss(stevey).
stealing(stevey,galactica-s3).
competitor(sumsum, appy).

rivarly(X):- company(X), competitor(X, appy).
business(X):- tech(X).
unethical(X):- boss(X), company(Y), business(StolenTech), stealing(X,StolenTech), developed(StolenTech,Y).
