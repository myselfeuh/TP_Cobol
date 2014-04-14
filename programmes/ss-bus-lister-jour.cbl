       program-id. ss-bus-lister-jour.

       input-output section.
       file-control.
           select FAffectations assign to "../ext/Affectation.dat"
               organization is indexed
               access mode is dynamic
                   record key is num-affect
                   alternate key is num-chauf with duplicates
                   alternate key is num-bus with duplicates
               status FAffectStatus.

           select FChaufNouv assign to "../ext/ChaufNouv.dat"
               organization is indexed
               access mode is dynamic
                   record key is numChaufN
                   alternate record key is nomN with duplicates
               status FChaufNouvStatus.

       data division.
       file section.
       FD FAffectations.
       01 enr-affectation.
           02 num-affect   pic 9(4).
           02 num-chauf    pic 9(4).
           02 num-bus      pic 9(4).
           02 date-debut   pic 9(8).
           02 date-fin     pic 9(8).

       FD FChaufNouv.
       01 enr-chauffeur.
           02 numChaufN    pic 9(4).
           02 nomN         pic x(30).
           02 prenomN      pic x(30).
           02 datePermisN  pic 9(8).


       working-storage section.
       01 FAffectStatus         pic x(2).
       01 FChaufNouvStatus      pic x(2).
       01 date-dispo            pic 9(8).

       01 i                     pic 9.
       01 quitter               pic x.
       01 fin-affect-fichier    pic x.
       01 fin-chauff-fichier    pic x.
       01 saisie                pic 9999/99/99.

       01 chauffeur-disponible  pic 9 value 1.
       01 aucun-resultat        pic 9.

       screen section.

      *----- Titres -----
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value '- Listing des bus disponibles -'.

      *----- Recherche -----
       01 s-plg-rechercher-date.
           02 line 3 col 2 value 'Choix de la date: '.
           02 s-date-dispo pic 9999/99/99 to date-dispo.

      *------ Structure d'affichage de donnée -------
       01 a-plg-separateur.
           02 line 4 col 1 value
           '----------------------------------------------------------'
               &'---------------------'.

       01 a-plg-chauffeur-data.
           02 a-numChaufN line i col 2    pic 9(4) from numChaufN.
           02 a-nomN line i col 8         pic x(30) from nomN.
           02 a-prenomN line i col 23     pic x(30) from prenomN.

      *------ Message d'erreur ------
       01 a-error-Affect-file-open.
           02 line 3 col 2 value 'Erreur Affectations.dat - status: '.
           02 a-FAffectStatus line 6 col 26 pic 99 from FAffectStatus.
       01 a-error-Chauf-file-open.
           02 line 3 col 2 value 'Erreur ChaufNouv.dat - status: '.
           02 a-FChaufNouvStatus line 6 col 24 pic 99 from
           FChaufNouvStatus.
       01 a-plg-aucun-resultat.
           02 line 6 value 'Aucun chauffeur de disponible à cette date'.

      *#################################################################
      *######################### PROGRAMME #############################
      *#################################################################

       procedure division.

       open input FChaufNouv
       open input FAffectations

       if FChaufNouvStatus not = '00' then
           display a-error-Chauf-file-open
       else if FAffectStatus not = '00' then
           display a-error-Affect-file-open
       else
           move 1 to aucun-resultat
           move 5 to i
           move 0 to numChaufN

           display a-plg-titre-global

           perform REINITIALISER
           display a-plg-separateur
           display s-plg-rechercher-date
           accept s-plg-rechercher-date
           perform ITERE-CHAUFFEURS

           if aucun-resultat = 1 then
               display a-plg-aucun-resultat
           end-if

           stop ' '

       close FAffectations
       close FChaufNouv

       goback
       .

      *#################################################################

       REINITIALISER.

       .

       ITERE-CHAUFFEURS.
           move 0 to fin-chauff-fichier
           move 0 to numChaufN
           start FChaufNouv key >= numChaufN

           perform with test after until (fin-chauff-fichier = 1)
               read FChaufNouv next
                   at end
                       move 1 to fin-chauff-fichier
                   not at end
                       perform ITERE-AFFECTATIONS
                       if chauffeur-disponible = 1 then
                           display a-plg-chauffeur-data
                           compute i = i + 1
                       end-if
               end-read
           end-perform
       .

       ITERE-AFFECTATIONS.
           move 1 to chauffeur-disponible
           move 0 to fin-affect-fichier
           move NumChaufN to num-chauf
           start Faffectations key = num-chauf

           perform with test after until (fin-affect-fichier = 1)
               read FAffectations next
                   at end
                       move 1 to fin-affect-fichier
                   not at end
                       if date-dispo > date-debut and date-dispo <
                       date-fin then
                           move 0 to chauffeur-disponible
                           move 0 to aucun-resultat
                       end-if
               end-read
           end-perform
       .

       end program ss-bus-lister-jour.
