       program-id. ss-chauffeurs-modif.

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
       01 choix-action             pic 9.
       01 quitter                  pic 9.
       01 nom-chauf                pic x(30).
       01 id-chauf                 pic 9(4).

       01 nv-nom-chauf             pic x(30).
       01 nv-prenom-chauf          pic x(30).
       01 nv-date-chauf            pic 9(8).

       screen section.
       01 a-plg-titre-global.
           02 blank screen.
           02 line 1 col 10 value '- Gestion des chauffeurs -'.
       01 a-plg-titre-ajoute.
           02 blank screen.
           02 line 1 col 10 value '- Ajoute un chauffeur -'.
       01 a-plg-titre-modifie.
           02 blank screen.
           02 line 1 col 10 value '- Modifie un chauffeur -'.
       01 a-plg-titre-supprime.
           02 blank screen.
           02 line 1 col 10 value '- Supprime un chauffeur -'.


       01 a-plg-fonctionnalites.
           02 line 3 col 2 value '1: Ajouter un chauffeur'.
           02 line 4 col 2 value '2: Modifier un chauffeur'.
           02 line 5 col 2 value '3: Supprimer un chauffeur'.
           02 line 7 col 2 value '9: Quitter'.
       01 s-plg-fonctionnalites.
           02 line 9 col 2 value 'Entrez votre choix : '.
           02 s-choix-action pic z to choix-action
           required.

       01 s-plg-recherche-id.
           02 line 3 col 2 value 'Id du chauffeur: '.
           02 s-id-chauf pic zzzz to id-chauf.
       01 s-plg-recherche-nom.
           02 line 4 col 2 value 'Nom du chauffeur: '.
           02 s-nom-chauf pic x(30) to nom-chauf.

       01 s-plg-formulaire-chauffeur-r.
           02 line 3 col 2 value 'Nouveau nom: '.
           02 s-nv-nom-chauf pic x(30) to nv-nom-chauf required.
           02 line 4 col 2 value 'Nouveau prenom: '.
           02 s-nv-prenom-chauf pic x(30) to nv-prenom-chauf required.
           02 line 5 col 2 value 'Nouvelle date de permis: '.
           02 s-nv-date-chauf pic zzzzzzzz to nv-date-chauf required.


       01 s-plg-formulaire-chauffeur.
           02 line 3 col 2 value 'Nouveau nom: '.
           02 s-nv-nom-chauf pic x(30) to nv-nom-chauf.
           02 line 4 col 2 value 'Nouveau prenom: '.
           02 s-nv-prenom-chauf pic x(30) to nv-prenom-chauf.
           02 line 5 col 2 value 'Nouvelle date de permis: '.
           02 s-nv-date-chauf pic zzzzzzzz to nv-date-chauf.

       01 a-plg-chauffeur-data.
           02 a-numChaufN line i col 2    pic 9(4) from numChaufN.
           02 a-nomN line i col 8         pic x(30) from nomN.
           02 a-prenomN line i col 23     pic x(30) from prenomN.
           02 a-datePermisN line i col 36 pic 9(8) from datePermisN.

       01 a-plg-efface-ecran.
           02 blank screen.
       01 a-plg-message-choix-invalide.
           02 line 20 col 1 value 'Choix invalide.'.
       01 a-plg-champs-exclusifs.
           02 line 20 col 1 value "Ne remplissez qu'un seul champs.".
       01 a-plg-champs-vide.
           02 line 20 col 1 value 'Remplissez au moins un champs.'.
       01 a-plg-chauffeur-introuvable.
           02 line 20 col 1 value 'Chauffeur introuvable.'.
       01 a-plg-modif-erreur.
           02 line 20 col 1 value 'Operation avortee'.
       01 a-plg-modif-succes.
           02 line 20 col 1 value 'Operation effectuee'.


       procedure division.

       open i-o FChaufNouv

       move 5 to i
       move 0 to numChaufN

       display a-plg-titre-global
       display a-plg-fonctionnalites

       move 0 to quitter

       perform until (quitter = 1)
           perform REINITIALISER
           display a-plg-fonctionnalites
           display s-plg-fonctionnalites
           accept s-plg-fonctionnalites

           evaluate choix-action
               when 1 perform AJOUTE
               when 2 perform MODIFIE
               when 3 perform SUPPRIME
               when 9 move 1 to quitter
               when other display a-plg-message-choix-invalide
           end-evaluate
       end-perform

       close FChaufNouv

       goback
       .

       REINITIALISER.
           display a-plg-efface-ecran
           display a-plg-titre-global
       .

       AJOUTE.
           perform REINITIALISER
           display a-plg-titre-ajoute

           display s-plg-formulaire-chauffeur-r
           accept s-plg-formulaire-chauffeur-r

           move 9999 to numChaufN
           start FChaufNouv key < numChaufN

           read FChaufNouv next
               at end
                   display a-plg-modif-erreur
               not at end
                   compute numChaufN = numChaufN + 1
           end-read

           move nv-nom-chauf to nomN
           move nv-prenom-chauf to prenomN
           move nv-date-chauf to datePermisN

           write ChaufNouv
           invalid key
               display a-plg-modif-erreur
           not invalid key
               display a-plg-modif-succes
           end-write

           stop ' '
       .

       MODIFIE.
           perform REINITIALISER
           display a-plg-titre-modifie

           perform RECHERCHE-CHAUFFEUR

           read FChaufNouv
           invalid key
               display a-plg-chauffeur-introuvable
           not invalid key
               display s-plg-formulaire-chauffeur
               accept s-plg-formulaire-chauffeur

               if nv-nom-chauf not = spaces and low-value then
               move nv-nom-chauf to nomN
               end-if
               if nv-prenom-chauf not = spaces and low-value then
               move nv-prenom-chauf to prenomN
               end-if
               if nv-date-chauf not = spaces and low-value then
               move nv-date-chauf to datePermisN
               end-if

               rewrite ChaufNouv
               invalid key
                   display a-plg-modif-erreur
               not invalid key
                   display a-plg-modif-succes
               end-rewrite
           end-read.

           stop ' '
       .

       SUPPRIME.
           perform REINITIALISER
           display a-plg-titre-supprime

           perform RECHERCHE-CHAUFFEUR

           delete FChaufNouv
           invalid key
               display a-plg-modif-erreur
           not invalid key
               display a-plg-modif-succes
           end-delete

           stop ' '
       .

       RECHERCHE-CHAUFFEUR.
           move 0 to id-chauf
           move ' ' to nom-chauf

           display s-plg-recherche-id
           display s-plg-recherche-nom

           accept s-plg-recherche-id
           accept s-plg-recherche-nom

           if id-chauf not = 0000 and nom-chauf not = ' ' then
               display a-plg-champs-exclusifs
           else if id-chauf = 0 and nom-chauf = ' ' then
               display a-plg-champs-vide
           else
               if id-chauf not = 0 then
                   move id-chauf to numChaufN
                   start FChaufNouv key = numChaufN
               else
                   move nom-chauf to nomN
                   start FChaufNouv key = nomN
               end-if
           end-if
       .

       end program ss-chauffeurs-modif.
