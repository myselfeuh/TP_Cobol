       program-id. main.

       data division.
       01 choix pic 9 value 0.
       01 mess-erreur  pic x(100).
       01 choix-statut pic 9.
           88 choix-ok value 1 false 0.
       01 statut-edition pic xx value 'KO'.

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
       01 a-plg-recapitulatif.
           02 line 4 col 1 value 'Edition du recapitulatif...'.
           02 line 6 col 1 value 'Statut de l''edition : '.
           02 line 6 col 23.
           02 a-statut-edition pic xx from statut-edition.
           02 line 8 col 1 value '1-Recommencer l''edition  du '
               &'recapitulatif'.
           02 line 9 col 1 value '9-Retour au menu principal'.

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
           display a-plg-titre
           perform with test after until choix-ok
               perform MENU-PPAL
           end-perform
       .

       goback.

       MENU-PPAL.
           display a-plg-titre
           perform with test after until choix-ok
               display a-plg-menu-ppal
               display s-plg-choix
               accept s-plg-choix
               evaluate choix
                   when 1 perform CHAUFFEURS
                   when 2 perform AFFECTATIONS
                   when 3 perform DISPONIBILITES
                   when 4 perform RECAPITULATIF
                   when 9 perform QUITTER
                   when other perform ERR-CHOIX
               end-evaluate
           end-perform
       .

       FICHE-CHAUFFEUR.
      * a modifier en appelant le sous programme 'ss-aff-chauffeurs'
           perform QUITTER.

       MODIF-CHAUFFEUR.
      * a modifier en appelant le sous programme 'ss-modif-chauffeurs'
           perform QUITTER.

       LISTE-CHAUFFEUR.
      * a modifier en appelant le sous programme 'ss-lister-chauffeurs'
           perform QUITTER.

       CHAUFFEURS.
           display a-plg-titre
           perform with test after until choix-ok
               display a-plg-menu-chauff
               display s-plg-choix
               accept s-plg-choix
               evaluate choix
                   when 1 perform FICHE-CHAUFFEUR
                   when 2 perform MODIF-CHAUFFEUR
                   when 3 perform LISTE-CHAUFFEUR
                   when 9 perform MENU-PPAL
                   when other perform ERR-CHOIX
               end-evaluate
           end-perform
       .

       CONSULT-AFFECT.
      * a modifier en appelant le sous programme 'ss-consult-affect'
           perform QUITTER
       .

       MODIF-AFFECT.
      * a modifier en appelant le sous programme 'ss-modif-affect'
           perform QUITTER
       .

       AJ-AFFECT.
      * a modifier en appelant le sous programme 'ss-aj-affect'
           perform QUITTER
       .

       SUPPR-AFFECT.
      * a modifier en appelant le sous programme 'ss-aj-affect'
           perform QUITTER
       .

       AFFECTATIONS.
           display a-plg-titre
           perform with test after until choix-ok
               display a-plg-menu-affect
               display s-plg-choix
               accept s-plg-choix
               evaluate choix
                   when 1 perform CONSULT-AFFECT
                   when 2 perform AJ-AFFECT
                   when 3 perform MODIF-AFFECT
                   when 4 perform SUPPR-AFFECT
                   when 9 perform MENU-PPAL
                   when other perform ERR-CHOIX
               end-evaluate
           end-perform
       .

       LISTE-CHAUFFEURS.
      * a modifier en appelant le sous programme 'ss-lister-chauffeurs'
      * mais avec un parametre de date !
           perform QUITTER
       .

       LISTE-BUS.
      * a modifier en appelant le sous programme 'ss-lister-bus'
      * mais avec un parametre de date !
           perform QUITTER
       .

       TROUVER-CHAUFFEUR.
      * a modifier en appelant le sous programme 'ss-lister-chauffeurs'
      * mais avec un parametre de date et un parametre de bus !
           perform QUITTER
       .

       TROUVER-DATE.
      * a modifier en appelant le sous programme 'ss-trouver-date'
      * avec un parametre de chauffeur et un parametre de bus
           perform QUITTER
       .

       DISPONIBILITES.
           display a-plg-titre
           perform with test after until choix-ok
               display a-plg-menu-dispo
               display s-plg-choix
               accept s-plg-choix
               evaluate choix
                   when 1 perform LISTE-CHAUFFEURS
                   when 2 perform LISTE-BUS
                   when 3 perform TROUVER-CHAUFFEUR
                   when 4 perform TROUVER-DATE
                   when 9 perform MENU-PPAL
                   when other perform ERR-CHOIX
               end-evaluate
           end-perform
       .

       RECAPITULATIF.
           display a-plg-titre
      * appeler le sous-programme 'ss-recap' et stocker le statut dans
      * la variable 'statut-edition'
           display a-plg-recapitulatif

           perform with test after until choix-ok
               display s-plg-choix
               accept s-plg-choix
               evaluate choix
                   when 1 perform RECAPITULATIF
                   when 9 perform MENU-PPAL
                   when other perform ERR-CHOIX
               end-evaluate
           end-perform
       .

       QUITTER.
           display a-plg-titre
           display a-fin-programme
           stop run
       .

       ERR-CHOIX.
           move 'Erreur : choix impossible !' to mess-erreur
           display a-plg-erreur
       .

       end program main.
