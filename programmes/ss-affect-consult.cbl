       program-id. ss-affect-consult.

       input-output section.
       file-control.
           select AFFECTATIONS assign to "../ext/Affectation.dat"
           organization is indexed
           access mode is dynamic
           record key is num-affect
           alternate key is num-chauf
           status fstatus.

       data division.
       file section.
       FD AFFECTATIONS.
       01 ENR-AFFECT.
           02 num-affect pic 9(4).
           02 num-chauf pic 9(4).
           02 num-bus pic 9(4).
           02 date-debut pic 9(8).
           02 date-fin pic 9(8).

       working-storage section.
       01 choix pic 9 value 0.
       01 mess-erreur  pic x(100).
       01 choix-statut pic 9.
           88 choix-ok value 1 false 0.
       01 ligne pic 99.
       01 i pic 99.

       01 finFichierAffect pic 9.
       01 fstatus pic x(02).
           88 ok                   value "00".
           88 optionnal-create     value "05".
           88 cle-multiple         value "22".
           88 pas-defini           value "23".
           88 erreur-indeterminee  value "30".
           88 non-optional-absent  value "35".

       screen section.
       01 a-plg-titre.
           02 blank screen.
           02 line 1 col 10 value '- Chauffeurs, Bus et Compagnie -'.
       01 a-plg-accueil.
           02 line 3 col 1 value 'Salut, vous etes dans le '
          & 'sous-programme ss-chauffeurs-lister.'.
       01 a-plg-titres-liste.
           02 line 5 col 1 value 'Num affect'.
           02 line 5 col 15 value 'Num chauf'.
           02 line 5 col 25 value 'Num bus'.
           02 line 5 col 35 value 'Date debut'.
           02 line 5 col 45 value 'Date fin'.
       01 a-plg-liste.
           02 line 4 col 1 value 'Liste des chauffeurs...'.
           02 line ligne col 1.
           02 s-num-affect pic 9(4) from num-affect.
           02 line ligne col 15.
           02 s-num-chauf pic 9(4) from num-chauf.
           02 line ligne col 25.
           02 s-num-bus pic 9(4) from num-bus.
           02 line ligne col 35.
           02 s-date-debut pic 9(8) from date-debut.
           02 line ligne col 45.
           02 s-date-fin pic 9(8) from date-fin.
       01 a-plg-continuer.
           02 line 22 col 1 value 'Appuyez sur une touche pour'
               & ' continuer...'.

       01 a-plg-status.
           02 line 1 col 1.
           02 a-fstatus pic 99 from fstatus.
       01 a-plg-erreur.
           02 line 22 col 1.
           02 a-message pic x(100) from mess-erreur.
       01 a-efface-erreur.
           02 line 22 blank line.

       procedure division.
           display a-plg-titre
           display a-plg-accueil
           open input AFFECTATIONS
           perform AFFICHER-AFFECT

       goback
       .

       AFFICHER-AFFECT.
      * A completer avec l'affichage des premieres affectations
           display a-plg-titres-liste
           move 0 to finFichierAffect
           move 5 to ligne
           move 0000 to num-affect
           start AFFECTATIONS key > num-affect
           if fstatus = '00'
               perform until finFichierAffect = 1
                   read AFFECTATIONS next
                       at end
                           move 1 to finFichierAffect
                           stop ' '
                           display a-plg-continuer
                       not at end
                           display a-plg-liste
                           add 1 to ligne
                           add 1 to i
                           if (function mod(i 3) = 0) then
                               display a-plg-titre
                               display a-plg-titres-liste
                               display a-plg-liste
                               stop ' '
                               display a-plg-continuer
                           end-if
                   end-read
               end-perform
           else
               move 'Erreur de lecture du fichier...' to mess-erreur
               display a-plg-erreur
               display a-plg-status
       .

       end program ss-affect-consult.
