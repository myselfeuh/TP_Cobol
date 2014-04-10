       program-id ss-bus-lister-jour.

       input-output section.
       file-control.
           select FAffectations assign to "../ext/Affectation.dat"
           organization is indexed
           access mode is dynamic
           record key is num-affect
           alternate key is num-chauf with duplicates
           alternate key is num-bus with duplicates
           status fstatus.

       data division.
       file section.
       FD FAffectations.
       01 enr-affectation.
           02 num-affect   pic 9(4).
           02 num-chauf    pic 9(4).
           02 num-bus      pic 9(4).
           02 date-debut   pic 9(8).
           02 date-fin     pic 9(8).


       working-storage section.
       01 FChaufNouvStatus         pic x(2).

       screen section.

      *----- Titres -----
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value '- Listing des bus disponibles -'.

      *----- Recherche -----
       01 s-plg-recherche-date.
           02 line 4 col 2 value 'Choix de la date: '.
           02 s-date-dispo pic 9999/99/99 to date-dispo.
      *


      *#################################################################
      *######################### PROGRAMME #############################
      *#################################################################

       procedure division.

       goback
       .

       end program ss-bus-lister-jour.
