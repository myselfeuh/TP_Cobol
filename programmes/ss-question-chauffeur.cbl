       program-id. ss-question-chauffeur.

       input-output section.
       file-control.
           select FAffectations assign to "../ext/Affectation.dat"
               organization is indexed
               access mode is dynamic
                   record key is fa-num-affect
                   alternate key is fa-num-chauff with duplicates
                   alternate key is fa-num-bus with duplicates
               status fa-status.

           select FChauffeurs assign to "../ext/ChaufNouv.dat"
               organization is indexed
               access mode is dynamic
                   record key is fc-num-chauff
                   alternate record key is fc-nom with duplicates
               status fc-status.

      *------------------------- DESCRIPTEURS --------------------------

       data division.
       file section.
       FD FAffectations.
       01 enr-affectation.
           02 fa-num-affect   pic 9(4).
           02 fa-num-chauff   pic 9(4).
           02 fa-num-bus      pic 9(4).
           02 fa-date-debut   pic 9(8).
           02 fa-date-fin     pic 9(8).

       FD FChauffeurs.
       01 enr-chauffeur.
           02 fc-num-chauff    pic 9(4).
           02 fc-nom           pic x(30).
           02 fc-prenom        pic x(30).
           02 fc-date-permis   pic 9(8).

      *-------------------------- VARIABLES ----------------------------

       working-storage section.
       01 fa-status                pic x(2).
       01 fc-status                pic x(2).
       01 i                        pic 9(2).
       01 fin-fa                   pic 9.
       01 fin-fc                   pic 9.
       01 aucun-resultat           pic 9.

       01 num-bus                  pic 9(4).
       01 date-affect              pic x(30).
       01 num-chauff               pic 9(4).

      *-------------------------- TITRE --------------------------------

       screen section.
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value
         "- Rechercher un chauffeur via un bus et une date donnée -".

      *-------------------------- SAISIE -------------------------------

       01 s-plg-num-bus.
           02 line 3 col 2 value "Id du bus: ".
           02 s-num-bus pic zzzz to num-bus
           required.
       01 s-plg-date.
           02 line 4 col 2 value "Date d'affectation: ".
           02 s-date-affect pic 99999999 to date-affect
           required.
       01 a-plg-separateur.
           02 line 6 col 1 value
           '----------------------------------------------------------'
               &'---------------------'.


      *-------------------------- RESULTATS ----------------------------

       01 a-plg-chauffeurs-colonnes.
           02 line 5 col 2 value 'Id'.
           02 line 5 col 8 value 'Nom'.
           02 line 5 col 39 value 'Prenom'.
           02 line 5 col 69 value 'Date permis'.
           02 line 6 col 1 value
           '----------------------------------------------------------'
               &'---------------------'.

       01 a-plg-chauffeur-data.
           02 a-fc-num-chauff line i col 2  pic 9(4) from fc-num-chauff.
           02 a-fc-nom line i col 8         pic x(30) from fc-nom.
           02 a-fc-prenom line i col 39     pic x(30) from fc-prenom.
           02 a-fc-date-permis line i col 69 pic 9999/99/99
               from fc-date-permis.

      *---------------------- MESSAGES & ERREURS -----------------------

       01 a-plg-aucun-resultat.
           02 line i col 2 value 'Aucun resultat.'.
       01 a-plg-efface-ecran.
           02 blank screen.

       01 a-error-fa-open.
           02 blank screen.
           02 line 3 col 2 value 'Erreur Affectations.dat - status: '.
           02 a-fa-status line 3 col 24 pic 99 from fa-status.
       01 a-error-fc-open.
           02 blank screen.
           02 line 3 col 2 value 'Erreur ChaufNouv.dat - status: '.
           02 a-fc-status line 3 col 24 pic 99 from fc-status.

      *#################################################################
      *######################### PROGRAMME #############################
      *#################################################################

       procedure division.

       open input FChauffeurs
       open input FAffectations

       if fa-status not = '00' then
           display a-error-fa-open
       else if fc-status not = '00' then
           display a-error-fc-open
       else
           move 8 to i
           display a-plg-titre-global
           move 1 to aucun-resultat

           perform REINITIALISER
           display s-plg-num-bus
           accept s-plg-num-bus
           display s-plg-date
           accept s-plg-date
           display a-plg-separateur

           perform FILTRE-AFFECTATIONS
           if aucun-resultat = 1 then
               display a-plg-aucun-resultat
           end-if

           stop ' '
           display a-plg-efface-ecran

       close FChauffeurs
       close FAffectations

       goback
       .

       FILTRE-AFFECTATIONS.
      * parcourir toutes les affectations
      * si la clef courante = param-bus et date courante > date-debut et
      * date courante < date-fin alors

      * recherche sur les chauffeurs key = resultat trouvé précédemment

       move 0 to fin-fa
       move 0 to fa-num-affect
       start FAffectations key >= fa-num-affect

       perform with test after until (fin-fa = 1)
           read FAffectations next
               at end
                   move 1 to fin-fa
               not at end
                   if date-affect > fa-date-debut
                   and date-affect < fa-date-fin
                   and num-bus = fa-num-bus then
                       perform RECHERCHE-CHAUFFEUR
                   end-if
           end-read
       end-perform
       .

      * DONNEES DE TEST
      * affect chauff          bus   debut    fin
      * 0001   0001 mozzati    0001  20120112 20120315
      * 0002   0001 mozzati    0009  20120401 20120620
      * 0003   0001 mozzati    0005  20120630 20120930
      * 0005   0002 batho      0007  20120126 20120405
      * 0006   0002 batho      0008  20120426 20120823

       RECHERCHE-CHAUFFEUR.
           move 1 to aucun-resultat
           move 0 to fin-fc

           move fa-num-chauff to fc-num-chauff
           start FChauffeurs key = fc-num-chauff

           perform with test after until (fin-fc = 1)
               read FChauffeurs next
                   at end
                       move 1 to fin-fc
                   not at end
                       if fc-num-chauff = fa-num-chauff
                           display a-plg-chauffeur-data
                           compute i = i + 1
                           move 0 to aucun-resultat
                       else
                           move 1 TO fin-fc
                       end-if
               end-read
           end-perform
       .

       REINITIALISER.
           display a-plg-efface-ecran
           display a-plg-titre-global
       .

       end program ss-question-chauffeur.
