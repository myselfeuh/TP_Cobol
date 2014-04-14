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
       01 type-formulaire          pic 9.
       01 choix-action             pic 9.
       01 quitter                  pic 9.
       01 nom-chauf                pic x(30).
       01 id-chauf                 pic 9(4).

       01 nv-nom-chauf             pic x(30).
       01 nv-prenom-chauf          pic x(30).
       01 nv-date-chauf            pic 9(8).

       screen section.

      *----- Titres -----
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

      *----- Menu -----
       01 a-plg-fonctionnalites.
           02 line 3 col 2 value '1: Ajouter un chauffeur'.
           02 line 4 col 2 value '2: Modifier un chauffeur'.
           02 line 5 col 2 value '3: Supprimer un chauffeur'.
           02 line 7 col 2 value '9: Quitter'.
       01 s-plg-fonctionnalites.
           02 line 9 col 2 value 'Entrez votre choix : '.
           02 s-choix-action pic z to choix-action
           required.

      *----- Recherche -----
       01 s-plg-recherche-id.
           02 line 3 col 2 value 'Id du chauffeur: '.
           02 s-id-chauf pic zzzz to id-chauf.
       01 s-plg-recherche-nom.
           02 line 4 col 2 value 'Nom du chauffeur: '.
           02 s-nom-chauf pic x(30) to nom-chauf.

      * --------- Formulaires -----------
       01 s-plg-form-nv-nom-r.
           02 line 3 col 2 value 'Nouveau nom: '.
           02 s-nv-nom-chauf pic x(30) to nv-nom-chauf required.
       01 s-plg-form-nv-prenom-r.
           02 line 4 col 2 value 'Nouveau prenom: '.
           02 s-nv-prenom-chauf pic x(30) to nv-prenom-chauf required.
       01 s-plg-form-nv-datePermis-r.
           02 line 5 col 2 value 'Nouvelle date de permis: '.
           02 s-nv-date-chauf pic 9999/99/99 to nv-date-chauf required.

       01 s-plg-form-nv-nom.
           02 line 4 col 2 value 'Ancien nom: '.
           02 a-nom-chauf pic x(30) from nomN.
           02 line 5 col 5 value 'Nouveau nom: '.
           02 s-nv-nom-chauf pic x(30) to nv-nom-chauf.
       01 s-plg-form-nv-prenom.
           02 line 7 col 2 value 'Ancien prenom: '.
           02 a-prenom-chauf pic x(30) from prenomN.
           02 line 8 col 5 value 'Nouveau prenom: '.
           02 s-nv-prenom-chauf pic x(30) to nv-prenom-chauf.
       01 s-plg-form-nv-datePermis.
           02 line 10 col 2 value 'Ancienne date de permis: '.
           02 a-date-chauf pic 9999/99/99 from datePermisN.
           02 line 11 col 5 value 'Nouvelle date de permis: '.
           02 s-nv-date-chauf pic 9999/99/99 to nv-date-chauf.

      *------ Structure d'affichage de donn�e -------
      *01 a-plg-chauffeur-data.
      *    02 a-numChaufN line i col 2    pic 9(4) from numChaufN.
      *    02 a-nomN line i col 8         pic x(30) from nomN.
      *    02 a-prenomN line i col 23     pic x(30) from prenomN.
      *    02 a-datePermisN line i col 36 pic 9999/99/99
      *        from datePermisN.

      *------ Messages utilisateur ------
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
       move 0 to type-formulaire

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

           move 1 to type-formulaire
           perform FORMULAIRE-CHAUFFEUR

           move 9999 to numChaufN
           start FChaufNouv key < numChaufN

           read FChaufNouv next
               at end
                   display a-plg-modif-erreur
               not at end
                   compute numChaufN = numChaufN + 1
           end-read

           move function upper-case(nv-nom-chauf) to nomN
           move function upper-case(nv-prenom-chauf) to prenomN
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

           move id-chauf to numChaufN
           start FChaufNouv key = numChaufN

           read FChaufNouv
           invalid key
               display a-plg-chauffeur-introuvable
           not invalid key
               move 0 to type-formulaire

               perform FORMULAIRE-CHAUFFEUR

               if nv-nom-chauf not = spaces and low-value then
                   move function upper-case(nv-nom-chauf)
                       to nomN
               end-if
               if nv-prenom-chauf not = spaces and low-value then
                   move function upper-case(nv-prenom-chauf)
                       to prenomN
               end-if
               if nv-date-chauf not = zeros and low-value then
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

           move id-chauf to numChaufN
           start FChaufNouv key = numChaufN

           delete FChaufNouv
           invalid key
               display a-plg-modif-erreur
           not invalid key
               display a-plg-modif-succes
           end-delete

           stop ' '
       .

       RECHERCHE-CHAUFFEUR.
           display s-plg-recherche-id
           accept s-plg-recherche-id
       .

       FORMULAIRE-CHAUFFEUR.
           if type-formulaire = 1 then
               display s-plg-form-nv-nom-r
               accept s-plg-form-nv-nom-r
               display s-plg-form-nv-prenom-r
               accept s-plg-form-nv-prenom-r
               display s-plg-form-nv-datePermis-r
               accept s-plg-form-nv-datePermis-r
           else
               display s-plg-form-nv-nom
               accept s-plg-form-nv-nom
               display s-plg-form-nv-prenom
               accept s-plg-form-nv-prenom
               display s-plg-form-nv-datePermis
               accept s-plg-form-nv-datePermis
           end-if
       .

       end program ss-chauffeurs-modif.
