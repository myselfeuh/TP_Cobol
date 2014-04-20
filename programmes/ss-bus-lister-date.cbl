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

           select FBus assign to "../ext/Fbus.dat"
               organization is indexed
               access mode is dynamic
                   record key is fb-numero
               status FBusStatus.

       data division.
       file section.
       FD FAffectations.
       01 enr-affectation.
           02 num-affect   pic 9(4).
           02 num-chauf    pic 9(4).
           02 num-bus      pic 9(4).
           02 date-debut   pic 9(8).
           02 date-fin     pic 9(8).

       FD FBus.
       01 enr-bus.
           02 fb-numero       pic 9(4).
           02 fb-marque       pic x(20).
           02 fb-nbplace      pic 9(3).
           02 fb-modele       pic x(20).
           02 fb-kms          pic 9(6).

       working-storage section.
       01 FAffectStatus         pic x(2).
       01 FBusStatus            pic x(2).
       01 date-dispo            pic 9(8).

       01 i                     pic 9(2).
       01 j                     pic 9(2).
       01 quitter               pic x.
       01 fin-affect-fichier    pic x.
       01 fin-bus-fichier       pic x.
       01 saisie                pic 9999/99/99.

       01 numero-bus            pic 9(4).
       01 bus-disponible        pic 9 value 1.
       01 aucun-resultat        pic 9.

       screen section.

      *----- Titres -----
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value '- Liste des bus'
           &' disponibles -'.

      *----- Recherche -----
       01 s-plg-rechercher-date.
           02 line 3 col 2 value 'Choix de la date: '.
           02 s-date-dispo pic 9999/99/99 to date-dispo.

      *------ Structure d'affichage de donnée -------
       01 a-plg-separateur.
           02 line j col 1 value
           '----------------------------------------------------------'
               &'---------------------'.

       01 a-plg-bus-data.
           02 a-fb-numero  line i col 2  pic 9(4)  from fb-numero.
           02 a-fb-marque  line i col 8  pic x(20) from fb-marque.
           02 a-fb-nbplace line i col 20 pic 9(3)  from fb-nbplace.
           02 a-fb-modele  line i col 30 pic x(20) from fb-modele.
           02 a-fb-kms     line i col 50 pic 9(6)  from fb-kms.


       01 a-plg-bus-header.
           02 line 5 col 2  value 'NUM:'.
           02 line 5 col 8  value 'MARQUE:'.
           02 line 5 col 20 value 'PLACES:'.
           02 line 5 col 30 value 'MODELE:'.
           02 line 5 col 50 value 'KMS:'.


      *------ Message d'erreur ------
       01 a-error-affect-file-open.
           02 blank screen.
           02 line 3 col 2 value 'Erreur Affectations.dat - status: '.
           02 a-FAffectStatus line 3 col 26 pic 99 from FAffectStatus.
       01 a-error-bus-file-open.
           02 blank screen.
           02 line 3 col 2 value 'Erreur FBus.dat - status: '.
           02 a-FBusStatus line 3 col 24 pic 99 from FBusStatus.
       01 a-plg-aucun-resultat.
           02 line 6 value 'Aucun bus disponible à cette date'.

      *#################################################################
      *######################### PROGRAMME #############################
      *#################################################################

       procedure division.

       open input FBus
       open input FAffectations

       if FBusStatus not = '00' then
           display a-error-bus-file-open
       else if FAffectStatus not = '00' then
           display a-error-Affect-file-open
       else
           move 7 to i
           display a-plg-titre-global
           move 1 to aucun-resultat
           move 0 to fb-numero

           perform REINITIALISER
           move 4 to j
           display a-plg-separateur
           display s-plg-rechercher-date
           accept s-plg-rechercher-date
           display a-plg-bus-header

           perform ITERE-BUS
           if aucun-resultat = 1 then
               display a-plg-aucun-resultat
           end-if

           stop ' '

       close FAffectations
       close FBus

       goback
       .

      *#################################################################

       REINITIALISER.

       .

       ITERE-BUS.
           move 0 to fin-bus-fichier
           move 0 to fb-numero
           start FBus key >= fb-numero

           perform with test after until (fin-bus-fichier = 1)
               read FBus next
                   at end
                       move 1 to fin-bus-fichier
                   not at end
                       perform ITERE-AFFECTATIONS
                       if bus-disponible = 1 then
                           display a-plg-bus-data
                           compute i = i + 1
                           move 0 to aucun-resultat
                       end-if
               end-read
           end-perform
       .

       ITERE-AFFECTATIONS.
           move 1 to bus-disponible
           move 0 to fin-affect-fichier

           move fb-numero to num-bus
           start Faffectations key = num-bus

           perform with test after until (fin-affect-fichier = 1)
               read FAffectations next
                   at end
                       move 1 to fin-affect-fichier
                   not at end
                       if fb-numero = num-bus
                           if date-dispo > date-debut
                           and date-dispo < date-fin then
                               move 0 to bus-disponible
                           end-if
                       else
                           move 1 TO fin-affect-fichier
                       end-if

               end-read
           end-perform
       .

       end program ss-bus-lister-jour.
