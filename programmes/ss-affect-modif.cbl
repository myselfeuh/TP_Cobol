       program-id. ss-affect-modif.

       input-output section.
           file-control.
           select fAffectation assign to "../ext/Affectation.dat"
               organization is indexed
               access mode is dynamic
                   record key is numAffect
                   alternate record key is numChaufA with duplicates
                   alternate record key is numBusA with duplicates
               status fstatus.

       data division.
       file section.
       fd fAffectation.
           01 rec-Affectation.
               02 numAffect        pic 9(4).
               02 numChaufA        pic 9(4).
               02 numBusA          pic 9(4).
               02 dateDebAffectA   pic 9(8).
               02 dateFinAffectA   pic 9(8).

       working-storage section.
       01 fstatus                  pic x(2).
       01 i                        pic 9(2).
       01 type-formulaire          pic 9.
       01 choix-action             pic 9.
       01 quitter                  pic 9.
       01 id-affect                pic 9(4).

       01 nv-numChaufA             pic 9(4).
       01 nv-numBusA               pic 9(4).
       01 nv-dateDebAffectA        pic 9(8).
       01 nv-dateFinAffectA        pic 9(8).

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
           02 line 3 col 2 value '1: Ajouter une affectation'.
           02 line 4 col 2 value '2: Modifier une affectation'.
           02 line 5 col 2 value '3: Supprimer une affectation'.
           02 line 7 col 2 value '9: Quitter'.
       01 s-plg-fonctionnalites.
           02 line 9 col 2 value 'Entrez votre choix : '.
           02 s-choix-action pic z to choix-action
           required.

       01 s-plg-recherche-id.
           02 line 3 col 2 value 'Id de l''affectation: '.
           02 s-id-chauf pic zzzz to id-affect.

      * --------- Formulaires -----------
       01 s-plg-form-nv-numChauf-r.
           02 line 3 col 2 value 'Numero de chauffeur: '.
           02 s-nv-numChaufA pic zzzz to nv-numChaufA required.
       01 s-plg-form-nv-numBus-r.
           02 line 4 col 2 value 'Numero de bus: '.
           02 s-nv-numBusA pic zzzz to nv-numBusA required.
       01 s-plg-form-nv-dateDeb-r.
           02 line 5 col 2 value 'Date de debut: '.
           02 s-nv-dateDebAffectA pic 9999/99/99
               to nv-dateDebAffectA required.
       01 s-plg-form-nv-dateFin-r.
           02 line 6 col 2 value 'Date de fin: '.
           02 s-nv-dateFinAffectA pic 9999/99/99
               to nv-dateFinAffectA required.

       01 s-plg-form-nv-numChauf.
           02 line 3 col 2 value 'Ancien numero de chauffeur: '.
           02 s-nv-numChaufA pic 9(4) from numChaufA .
           02 line 4 col 5 value 'Nouveau numero de chauffeur: '.
           02 s-nv-numChaufA pic zzzz to nv-numChaufA .
       01 s-plg-form-nv-numBus.
           02 line 6 col 2 value 'Ancien numero de bus: '.
           02 s-nv-numBusA pic 9(4) from numBusA .
           02 line 7 col 5 value 'Nouveau numero de bus: '.
           02 s-nv-numBusA pic zzzz to nv-numBusA .
       01 s-plg-form-nv-dateDeb.
           02 line 9 col 2 value 'Anncienne date de debut: '.
           02 s-nv-dateDebAffectA pic 9999/99/99
               from dateDebAffectA .
           02 line 10 col 5 value 'Nouvelle date de debut: '.
           02 s-nv-dateDebAffectA pic 9999/99/99
               to nv-dateDebAffectA .
       01 s-plg-form-nv-dateFin.
           02 line 12 col 2 value 'Ancienne date de fin: '.
           02 s-nv-dateFinAffectA pic 9999/99/99
               from dateFinAffectA .
           02 line 13 col 5 value 'Nouvelle date de fin: '.
           02 s-nv-dateFinAffectA pic 9999/99/99
               to nv-dateFinAffectA .

      *------ Structure d'affichage de donnée -------
      *01 a-plg-affect-data.
      *    02 a-numAffect line i col 2         pic 9(4) from numAffect.
      *    02 a-numChaufA line i col 8         pic 9(4) from numChaufA.
      *    02 a-numBusA line i col 23          pic 9(4) from numBusA.
      *    02 a-dateDebAffectA line i col 36   pic 9999/99/99
      *        from dateDebAffectA.
      *    02 a-dateFinAffectA line i col 36   pic 9999/99/99
      *        from dateFinAffectA.

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

       open i-o fAffectation

       move 5 to i
       move 0 to numAffect

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

       close fAffectation

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
           perform FORMULAIRE

           move 9999 to numAffect
           start fAffectation key < numAffect

           read fAffectation next
               at end
                   display a-plg-modif-erreur
               not at end
                   compute numAffect = numAffect + 1
           end-read

           move nv-numChaufA to numChaufA
           move nv-numBusA to numBusA
           move nv-dateDebAffectA to dateDebAffectA
           move nv-dateFinAffectA to dateFinAffectA

           write rec-Affectation
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

           display s-plg-recherche-id
           accept s-plg-recherche-id

           move id-Affect to numAffect
           start fAffectation key = numAffect

           read fAffectation
           invalid key
               display a-plg-chauffeur-introuvable
           not invalid key
               move 0 to type-formulaire

               perform FORMULAIRE

               if nv-numChaufA not = zeros and low-value then
                   move nv-numChaufA to numChaufA
               end-if
               if nv-numBusA not = zeros and low-value then
                   move nv-numBusA to numBusA
               end-if
               if nv-dateDebAffectA not = zeros and low-value then
                   move nv-dateDebAffectA to dateDebAffectA
               end-if
               if nv-dateFinAffectA not = zeros and low-value then
                   move nv-dateFinAffectA to dateFinAffectA
               end-if

               rewrite rec-Affectation
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

           display s-plg-recherche-id
           accept s-plg-recherche-id

           move id-Affect to numAffect
           start fAffectation key = numAffect

           delete fAffectation
           invalid key
               display a-plg-modif-erreur
           not invalid key
               display a-plg-modif-succes
           end-delete

           stop ' '
       .

       FORMULAIRE.
           if type-formulaire = 1 then
               display s-plg-form-nv-numChauf-r
               accept s-plg-form-nv-numChauf-r
               display s-plg-form-nv-numBus-r
               accept s-plg-form-nv-numBus-r
               display s-plg-form-nv-dateDeb-r
               accept s-plg-form-nv-dateDeb-r
               display s-plg-form-nv-dateFin-r
               accept s-plg-form-nv-dateFin-r
           else
               display s-plg-form-nv-numChauf
               accept s-plg-form-nv-numChauf
               display s-plg-form-nv-numBus
               accept s-plg-form-nv-numBus
               display s-plg-form-nv-dateDeb
               accept s-plg-form-nv-dateDeb
               display s-plg-form-nv-dateFin
               accept s-plg-form-nv-dateFin
           end-if
       .

       end program ss-affect-modif.
