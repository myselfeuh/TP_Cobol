       program-id. ss-question-trouver-date.

       input-output section.
       file-control.
           select FAffectations assign to "../ext/Affectation.dat"
               organization is indexed
               access mode is dynamic
                   record key is fa-num-affect
                   alternate key is fa-num-chauf with duplicates
                   alternate key is fa-num-bus with duplicates
               status fa-status.

      *------------------------- DESCRIPTEURS --------------------------

       data division.
       file section.
       FD FAffectations.
       01 enr-affectation.
           02 fa-num-affect   pic 9(4).
           02 fa-num-chauf    pic 9(4).
           02 fa-num-bus      pic 9(4).
           02 fa-date-debut   pic 9(8).
           02 fa-date-fin     pic 9(8).

      *-------------------------- VARIABLES ----------------------------

       working-storage section.
       01 fa-status                pic x(2).
       01 fc-status                pic x(2).
       01 i                        pic 9(2).
       01 fin-fichier              pic 9.
       01 aucun-resultat           pic 9.

       01 num-bus                  pic 9(4).
       01 date-affect              pic x(30).
       01 num-chauff               pic 9(4).

      *-------------------------- TITRE --------------------------------

       screen section.
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value
               "- Rechercher la date d'affectation d'un bus"
                   &" donné pour un chauffeur donné -".

      *-------------------------- SAISIE -------------------------------

       01 s-plg-num-bus.
           02 line 3 col 2 value "Id du bus: ".
           02 s-num-bus pic zzzz to num-bus
           required.
       01 s-plg-num-chauff.
           02 line 4 col 2 value "Id du chauffeur: ".
           02 s-num-chauff pic zzzz to num-chauff
           required.
       01 a-plg-separateur.
           02 line 6 col 1 value
           '----------------------------------------------------------'
               &'---------------------'.


      *---------------------- MESSAGES & ERREURS -----------------------

       01 a-plg-aucun-resultat.
           02 line i col 2 value 'Aucun resultat.'.
       01 a-plg-efface-ecran.
           02 blank screen.

       01 a-error-fa-open.
           02 blank screen.
           02 line 3 col 2 value 'Erreur Affectations.dat - status: '.
           02 a-fa-status line 3 col 24 pic 99 from fa-status.

      *#################################################################
      *######################### PROGRAMME #############################
      *#################################################################

       procedure division.

       open input FAffectations

       if fa-status not = '00' then
           display a-error-fa-open
       else
           move 8 to i
           display a-plg-titre-global
           move 1 to aucun-resultat

           perform REINITIALISER
           display s-plg-num-bus
           accept s-plg-num-bus
           display a-plg-separateur

           perform ITERE-BUS
           if aucun-resultat = 1 then
               display a-plg-aucun-resultat
           end-if

           stop ' '

       close FAffectations

       goback
       .

       ITERE-BUS

       .

       REINITIALISER.
           display a-plg-efface-ecran
           display a-plg-titre-global
       .

       end program ss-question-trouver-date.


