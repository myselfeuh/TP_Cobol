       program-id. ss-chauffeurs-lister.

       input-output section.
           file-control.
           select FChaufNouv assign to "../ext/ChaufNouv.dat"
               organization is indexed
               access mode is dynamic
                   record key is numChaufN
               status FChaufNouvStatus.

       data division.
       file section.
       fd FChaufNouv.
           01 ChaufNouv.
               02 numChaufN    pic 9(4).
               02 nomN         pic x(30).
               02 prenomN      pic x(30).
               02 datePermisN  pic 9(8).

       working-storage section.
       01 FChaufNouvStatus         pic x(2).
       01 limite                   pic 9(2).
       01 fin-fichier              pic 9.
       01 i                        pic 9(2).

       screen section.
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value '- Chauffeurs, Bus et Compagnie -'.
       01 a-plg-titre-colonne.
           02 line 3 col 2 value 'Id:'.
           02 line 3 col 8 value 'Nom:'.
           02 line 3 col 23 value 'Prenom:'.
           02 line 3 col 36 value 'Date du permis:'.
       01 a-plg-menu.
           02 line 18 col 1 value '1-Afficher les chauffeurs suivants'.
           02 line 19 col 1 value '9-Retour au menu principal'.
       01 a-plg-afficher.
           02 line 10 col 1 value 'Liste des chauffeurs...'.

       01 a-plg-chauffeur-data.
           02 a-numChaufN line i col 2    pic 9(4) from numChaufN.
           02 a-nomN line i col 8         pic x(30) from nomN.
           02 a-prenomN line i col 23     pic x(30) from prenomN.
           02 a-datePermisN line i col 36 pic 9(8) from datePermisN.

       01 a-plg-message-utilisateur.
           02 line 20 col 1 value 'Appuyer sur une touche...'.
       01 a-plg-efface-ecran.
           02 blank screen.
       01 a-error-write.
           02 blank screen.
           02 line 2 col 10 value "Erreur lors de l'écriture...".

       procedure division.

       open input FChaufNouv
       if FChaufNouvStatus not = '00' then
          display a-error-write
       end-if

       move 5 to i
       move 1 to limite
       move 0 to fin-fichier
       move 0 to numChaufN
       start FChaufNouv key > numChaufN

       display a-plg-titre-global
       display a-plg-titre-colonne

       perform with test after until (
           fin-fichier = 1
           or FChaufNouvStatus = '35'
       )
           read FChaufNouv next
               at end
                   move 1 to fin-fichier
                   display a-plg-message-utilisateur
                   stop ' '
               not at end
                   perform AFFICHER
                   compute i = i + 1

                   compute limite = function mod(limite 4)

                   if limite = 0 then
                       display a-plg-message-utilisateur
                       stop ' '
                       perform REINITIALISER
                   end-if
           end-read
       end-perform
       close FChaufNouv.
       goback
       .

       AFFICHER.
      * A completer avec l'affichage des 10 premiers chauffeurs
           display a-plg-chauffeur-data
           compute limite = limite + 1
       .

       REINITIALISER.
      * TODO
           display a-plg-efface-ecran

           display a-plg-titre-global
           display a-plg-titre-colonne

           move 5 to i
           move 1 to limite
       .

       end program ss-chauffeurs-lister.
