       program-id. ss-chauffeurs-afficher.

       input-output section.
           file-control.
           select FChaufNouv assign to "../ext/ChaufNouv.dat"
               organization is indexed
               access mode is dynamic
                   record key is numChaufN
                   alternate record key is nomN with duplicates
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
       01 i                        pic 9(2).
       01 choix-type-recherche     pic 9.
       01 quitter                  pic 9.
       01 nom-chauffeur            pic x(30).
       01 id-chauffeur             pic 9(4).

       screen section.
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value "- Recherche d'un chauffeur -".

       01 a-plg-type-recherche.
           02 line 3 col 2 value '1: recherche par identifiant'.
           02 line 4 col 2 value '2: recherche par nom'.
           02 line 6 col 2 value '9: quitter'.
       01 s-plg-type-recherche.
           02 line 8 col 2 value 'Entrez votre choix : '.
           02 s-choix-type-recherche pic z to choix-type-recherche
           required.

       01 s-plg-recherche-id.
           02 line 3 col 2 value 'Id du chauffeur: '.
           02 s-id-chauffeur pic zzzz to id-chauffeur
           required.
       01 s-plg-recherche-nom.
           02 line 3 col 2 value 'Nom du chauffeur: '.
           02 s-nom-chauffeur pic x(30) to nom-chauffeur
           required.

       01 a-plg-chauffeur-data.
           02 a-numChaufN line i col 2    pic 9(4) from numChaufN.
           02 a-nomN line i col 8         pic x(30) from nomN.
           02 a-prenomN line i col 23     pic x(30) from prenomN.
           02 a-datePermisN line i col 36 pic 9(8) from datePermisN.
       01 a-plg-message-continuer.
           02 line 20 col 1 value 'Appuyer sur une touche...'.
       01 a-plg-message-choix-invalide.
           02 line 20 col 1 value 'Choix invalide.'.
       01 a-plg-message-aucun-resultat.
           02 line i col 2 value 'Aucun resultat.'.

       01 a-plg-efface-ecran.
           02 blank screen.
       01 a-affiche-erreur.
           02 blank screen.
           02 line 2 col 10 value "Erreur lors de l'écriture...".

       procedure division.

       open input FChaufNouv

       move 5 to i
       move 0 to numChaufN

       display a-plg-titre-global
       display a-plg-type-recherche

       move 0 to quitter

       perform until (quitter = 1)
           perform REINITIALISER
           display a-plg-type-recherche
           display s-plg-type-recherche
           accept s-plg-type-recherche

           if choix-type-recherche = 1 then
               perform REINITIALISER
               perform RECHERCHER-PAR-ID
           else if choix-type-recherche = 2 then
               perform REINITIALISER
               perform RECHERCHER-PAR-NOM
           else if choix-type-recherche = 9 then
               move 1 to quitter
           else
               display a-plg-message-choix-invalide
           end-if
       end-perform
       goback
       .

       RECHERCHER-PAR-ID.
      *    fonction principale
           display s-plg-recherche-id.
           accept s-plg-recherche-id.

           move id-chauffeur to numChaufN
           start FChaufNouv key = numChaufN

           perform RECHERCHER
       .
       RECHERCHER-PAR-NOM.
      *    fonction principale
           display s-plg-recherche-nom.
           accept s-plg-recherche-nom.

           move nom-chauffeur to nomN
           start FChaufNouv key = nomN

           perform RECHERCHER
       .

       RECHERCHER.
      * A completer avec l'affichage des 10 premiers chauffeurs
           if FChaufNouvStatus = '00'
              read FChaufNouv
              display a-plg-chauffeur-data
           else
              display a-plg-message-aucun-resultat
           end-if

           stop ' '
       .

       REINITIALISER.
           display a-plg-efface-ecran
           display a-plg-titre-global


       end program ss-chauffeurs-afficher.
