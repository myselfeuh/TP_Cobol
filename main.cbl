       program-id. main.

       data division.
       01 choix pic 9 value 0.
       01 mess-erreur  pic x(100).
       01 choix-statut pic 9.
           88 choix-ok value 1 false 0.

       screen section.
       01 a-plg-titre.
           02 blank screen.
           02 line 1 col 10 value '- Chauffeurs, Bus et Compagnie -'.
       01 a-plg-menu-ppal.
           02 line 4 col 1 value 'Menu principal : '.
           02 line 6 col 1 value '1-Gestion des chauffeurs'.
           02 line 7 col 1 value '2-Gestion des affectations'.
           02 line 8 col 1 value '3-Consultation des disponibilites'.
           02 line 9 col 1 value '4-Recapitulatif'.
           02 line 11 col 1 value '9-Quitter'.
       01 a-plg-menu-chauff.
           02 line 4 col 1 value 'Menu chauffeurs : '.
           02 line 6 col 1 value '1-Consulter la fiche d''un chauffeur'.
           02 line 7 col 1 value '2-Ajout, suppression, modification'.
           02 line 8 col 1 value '3-Lister tous les chauffeurs'.
           02 line 10 col 1 value '9-Retour au menu principal'.
       01 a-plg-menu-affect.
           02 line 4 col 1 value 'Menu des affectations :'.
           02 line 6 col 1 value '1-Consulter les affectations'.
           02 line 7 col 1 value '2-Ajouter une affectation'.
           02 line 8 col 1 value '3-Modifier une affectation'.
           02 line 9 col 1 value '4-Supprimer une affectation'.
           02 line 11 col 1 value '9-Retour au menu principal'.
       01 a-plg-menu-dispo.
           02 line 4 col 1 value 'Menu des disponibilites :'.
           02 line 6 col 1 value '1-Liste des chauffeurs disponibles '
               &'un jour donne'.
           02 line 7 col 1 value '2-Liste des bus disponibles un jour '
               &'donne'.
           02 line 8 col 1 value '3-Trouver un chauffeur affecte a un '
               &'bus donne un jour donne'.
           02 line 9 col 1 value '4-Trouver la(les) date(s) '
               &'d''affectation d''un bus donne a un chauffeur donne'.
           02 line 11 col 1 value '9-Retour au menu principal'.

       01 s-plg-choix.
           02 line 20 col 1 value 'Entrez votre choix : '.
           02 s-choix pic z to choix required.
       01 a-plg-erreur.
           02 line 22 col 1.
           02 a-message pic x(100) from mess-erreur.
       01 a-efface-erreur.
           02 line 22 blank line.
       01 a-fin-programme.
           02 line 4 col 13 value '! FIN DU PROGRAMME !'.

       procedure division.
           set choix-ok to false
           perform with test after until choix-ok
               perform MENU-PPAL
           end-perform.

       goback.

       MENU-PPAL.
           display a-plg-titre.
           display a-plg-menu-ppal.
           display s-plg-choix.
           accept s-plg-choix.

           evaluate choix
               when 1 perform CHAUFFEURS
               when 2 perform AFFECTATIONS
               when 3 perform DISPONIBILITES
               when 4 perform RECAPITULATIF
               when 9 perform QUITTER
               when other perform ERR-CHOIX
           end-evaluate.

       FICHE-CHAUFFEUR.
      * a modifier en appelant le sous programme 'afficher-chauffeurs'
           perform QUITTER.

       MODIF-CHAUFFEUR.
      * a modifier en appelant le sous programme 'modifier-chauffeurs'
           perform QUITTER.

       LISTE-CHAUFFEUR.
      * a modifier en appelant le sous programme 'ss-lister-chauffeurs'
           perform QUITTER.

       CHAUFFEURS.
           display a-plg-titre.
           set choix-ok to true.
           display a-plg-menu-chauff.
           display s-plg-choix.
           accept s-plg-choix.

           evaluate choix
               when 1 perform FICHE-CHAUFFEUR
               when 2 perform MODIF-CHAUFFEUR
               when 3 perform LISTE-CHAUFFEUR
               when 9 perform MENU-PPAL
               when other perform ERR-CHOIX
           end-evaluate.

       AFFECTATIONS.
           display a-plg-titre.
           set choix-ok to true.
           display a-plg-menu-affect.
           display s-plg-choix.
           accept s-plg-choix.

       DISPONIBILITES.
           display a-plg-titre.
           set choix-ok to true.
           display a-plg-menu-dispo.
           display s-plg-choix.
           accept s-plg-choix.

       RECAPITULATIF.
           display a-plg-titre.
           set choix-ok to true.
           display s-plg-choix.
           accept s-plg-choix.

       QUITTER.
           display a-plg-titre.
           display a-fin-programme.
           stop run.

       ERR-CHOIX.
           move 'Erreur : choix impossible !' to mess-erreur.
           display a-plg-erreur.

       end program main.
