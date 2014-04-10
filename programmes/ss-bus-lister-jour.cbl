

       program-id. main.

       data division.
       working-storage section.
       01 choix pic 9 value 0.
       01 mess-erreur  pic x(100).
       01 choix-statut pic 9.
           88 choix-ok value 1 false 0.
       01 statut-edition pic xx value 'KO'.
       01 nom-ssprog pic x(40).

       screen section.
       01 a-plg-titre.
           02 blank screen.
           02 line 1 col 10 value '- Chauffeurs, Bus et Compagnie -'.
       01 a-plg-menu-ppal.
           02 line 4 col 1 value        program-id ss-bus-lister-jour.

       end program ss-bus-lister-jour.
