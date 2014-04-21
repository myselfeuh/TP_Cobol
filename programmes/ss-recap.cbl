       identification division.
       program-id. ss-recap.

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

           select FBus assign to "../ext/Fbus.dat"
               organization is indexed
               access mode is dynamic
                   record key is fb-numero
               status fb-status.

           select Frecap assign to "../ext/Recapitulatif.txt"
               organization is sequential
               status fr-status.

      *------------------------- DESCRIPTEURS --------------------------
       data division.
       file section.
       FD Frecap.
           01 Ligne.
               02 contenu-ligne   pic x(80).

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

       FD FBus.
       01 enr-bus.
           02 fb-numero       pic 9(4).
           02 fb-marque       pic x(20).
           02 fb-nbplace      pic 9(3).
           02 fb-modele       pic x(20).
           02 fb-kms          pic 9(6).

      *-------------------------- VARIABLES ----------------------------
       working-storage section.
       01 fc-status        pic x(2).
       01 fa-status        pic x(2).
       01 fr-status        pic x(2).
       01 fb-status        pic x(2).
       01 fin-fa           pic 9.
       01 fin-fc           pic 9.
       01 fin-fb           pic 9.
       01 i                pic 9(2).
       01 mess-erreur      pic x(100).
       01 statut-edition   pic xxx value 'NON'.
       01 prg-err-name     pic x(30) value 'none'.
       01 choix            pic 9 value 0.
       01 choix-statut     pic 9.
           88 choix-ok value 1 false 0.

      *---------------------- SCREEN SECTION ---------------------------
       screen section.
       01 a-plg-titre.
           02 blank screen.
           02 line 1 col 10 value '- Chauffeurs, Bus et Compagnie -'.
       01 s-plg-choix.
           02 line 20 col 1 value 'Entrez votre choix : '.
           02 s-choix pic z to choix required.
       01 a-plg-recapitulatif.
           02 line 4 col 1 value 'Edition du recapitulatif...'.
           02 line 6 col 1 value 'Fichier sauvegarde : '.
           02 line 6 col 23.
           02 a-statut-edition pic xxx from statut-edition.
           02 line 8 col 1 value '1-Sauvegarder le fichier '
               &'recapitulatif'.
           02 line 9 col 1 value '9-Retour au menu principal'.
      *---------------------- MESSAGES & ERREURS -----------------------
       01 a-plg-confirmation.
           02 line 14 col 3 value 'Fichier sauvegarde avec succes !'.
       01 a-error-open.
           02 line 15 col 1 value "Erreur lors de l'ouverture de : ".
           02 line 15 col 35.
           02 a-prg-name pic x(30) from prg-err-name.
       01 a-plg-erreur.
           02 line 22 col 1.
           02 a-message pic x(100) from mess-erreur.

      *#################################################################
      *######################### PROGRAMME #############################
      *#################################################################
       procedure division.
           display a-plg-titre
           move 'NON' to statut-edition

      *--- Affichage du menu ---
           move 0 to choix-statut
           perform with test after until choix-ok
               display a-plg-recapitulatif
               display s-plg-choix
               accept s-plg-choix
               evaluate choix
                   when 1 perform IMPRESSION-RECAP
                   when 9 perform RETOUR
                   when other perform ERR-CHOIX
               end-evaluate
           end-perform
       goback
       .

       IMPRESSION-RECAP.
      *--- ouverture des fichiers ---
       open input FChauffeurs
       if fc-status not = '00' then
           move 'FChauffeurs' to prg-err-name
           display a-error-open
       end-if

       open input FAffectations
       if fa-status not = '00' then
           move 'FAffectations' to prg-err-name
           display a-error-open
       end-if

       open input FBus
       if fa-status not = '00' then
           move 'FBus' to prg-err-name
           display a-error-open
       end-if

       open output FRecap
       if fr-status not = '00' then
          move 'Frecap' to prg-err-name
          display a-error-open
       end-if

      *--- initialisation des titres du fichier recap ---
       move '       ----- Fichier recapitulatif -----' to contenu-ligne
       write Ligne
       move '.' to contenu-ligne
       write Ligne
       move 'Numero bus | Nombre de places ' to contenu-ligne
       write Ligne
       move '-------------------------------------------------------'
               &'----------' to contenu-ligne
       write Ligne


      *--- lecture des fichiers ---
       move 0 to fb-numero
       move 0 to fin-fb
       start FBus key >= fb-numero
       if fb-status = '00' then
           perform with test after until (fin-fb = 1)
               read FBus next
                   at end
                       move 1 to fin-fb
                   not at end
                       move ' ' to contenu-ligne
                       string fb-numero '         ' fb-nbplace
                           into contenu-ligne
                       write Ligne
           end-perform
           display a-plg-confirmation
           move 'OUI' to statut-edition
       end-if
       close FRecap
       close FChauffeurs
       close FAffectations
       close FBus
       .

       ERR-CHOIX.
           move 'Erreur : choix impossible !' to mess-erreur
           display a-plg-erreur
       .

       RETOUR.
       goback
       .
       end program ss-recap.
