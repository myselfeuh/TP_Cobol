       program-id. ss-chauffeurs-lister.

       data division.
       working-storage section.
       01 choix pic 9 value 0.
       01 mess-erreur  pic x(100).
       01 choix-statut pic 9.
           88 choix-ok value 1 false 0.

      *file output section.
      *    file-control.
      *    select Fchauffeur assign to 'chauffeur\Fchauffeur.dat'
      *        organization is sequential
      *        status fstat
      *
      *file section.
      *fd Fchauffeur.
      *    01 chauffeur.
      *        02 nom          pic x(30).
      *        02 prenom       pic x(30).
      *        02 datepermis   pic 9(8).
      *        02 tabaffect.
      *            03 affect occurs 20.
      *                04 numbus           pic 9(4).
      *                04 dateDebAffect    pic 9(8).
      *                04 dateFinAffect    pic 9(8).

       screen section.
       01 a-plg-titre.
           02 blank screen.
           02 line 1 col 10 value '- Chauffeurs, Bus et Compagnie -'.
       01 a-plg-accueil.
           02 line 3 col 1 value 'Salut, vous etes dans le '
          & 'sous-programme ss-chauffeurs-lister.'.
       01 a-plg-menu.
           02 line 5 col 1 value '1-Afficher la liste de tous les '
          & 'chauffeurs'.
           02 line 6 col 1 value '9-Retour au menu principal'.
       01 a-plg-afficher.
           02 line 10 col 1 value 'Liste des chauffeurs...'.

       01 s-plg-choix.
           02 line 20 col 1 value 'Entrez votre choix : '.
           02 s-choix pic z to choix required.
       01 a-plg-erreur.
           02 line 22 col 1.
           02 a-message pic x(100) from mess-erreur.
       01 a-efface-erreur.
           02 line 22 blank line.

       procedure division.
           display a-plg-titre
           set choix-ok to false
           perform with test after until choix-ok
               display a-plg-menu
               display s-plg-choix
               accept s-plg-choix
               evaluate choix
                   when 1 perform AFFICHER
                   when 9 set choix-ok to true
                   when other perform ERR-CHOIX
               end-evaluate
           end-perform
       goback
       .

       AFFICHER.
      * A completer avec l'affichage de tous les chauffeurs
       display a-plg-afficher
       .
       ERR-CHOIX.
           move 'Erreur : choix impossible !' to mess-erreur
           display a-plg-erreur
       .

       end program ss-chauffeurs-lister.
