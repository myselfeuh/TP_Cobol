       identification division.
       program-id. parser.

       input-output section.
           file-control.
           select FChauffeurs assign to "Fchauffeur.dat"
               organization is sequential
               status FChauffeursStatus.

           select FChaufNouv assign to "ChaufNouv.dat"
               organization is indexed access dynamic
                   record key is numchaufN
               status FChaufNouvStatus.

           select FAffectation assign to "Affectation.dat"
               organization is indexed access dynamic
                   record key is numAffect
                   alternate record key is numChaufA with duplicates
                   alternate record key is numBusA with duplicates
               status FAffectationStatus.

       data division.
       file section.
       fd FChauffeurs.
           01 Chauffeur.
               02 nom          pic x(30).
               02 prenom       pic x(30).
               02 datePermis   pic 9(8).
               02 tabAffect.
                   03 affect occurs 20.
                       04 numBus           pic 9(4).
                       04 dateDebAffect    pic 9(8).
                       04 dateFinAffect    pic 9(8).

       fd FChaufNouv.
           01 ChaufNouv.
               02 numChaufN    pic 9(4).
               02 nomN         pic x(30).
               02 prenomN      pic x(30).
               02 datePermisN  pic 9(8).

       fd FAffectation.
           01 Affectation.
               02 numAffect        pic 9(4).
               02 numChaufA        pic 9(4).
               02 numBusA          pic 9(4).
               02 dateDebAffectA   pic 9(8).
               02 dateFinAffectA   pic 9(8).

       working-storage section.
       01 FChauffeursStatus        pic x(2).
       01 FChaufNouvStatus         pic x(2).
       01 FAffectationStatus       pic x(2).
       01 fin-fichier              pic 9 value 0.
       01 i                        pic 9(2).
       01 j                        pic 9(2).

       screen section.
       01 a-blank-screen.
           02 blank screen.

       01 a-plg-chauffeur-data.
           02 a-nom line i col 2 pic x(30) from nom.
           02 a-nom line i col 17 pic x(30) from prenom.
           02 a-datePermis line i col 30 pic 9(8) from datePermis.

       01 a-plg-affectation-numAffect.
           02 line i col 10 value "No de l'affectation: ".
           02 a-numAffect line i col 33 pic 9(4)
           from numAffect.

       01 a-plg-affectation-numBus.
           02 line i col 10 value 'No du bus: '.
           02 a-numBus line i col 23 pic 9(4) from numBus(j).

       01 a-plg-affectation-dateDebAffect.
           02 line i col 10 value "Debut de l'affectation: ".
           02 a-debAffect line i col 37 pic 9(8)
           from dateDebAffect(j).

       01 a-plg-affectation-dateFinAffect.
           02 line i col 10 value "Fin de l'affectation: ".
           02 a-finAffect line i col 37 pic 9(8)
           from dateFinAffect(j).

       01 a-error-write.
           02 blank screen.
           02 line 2 col 10 value "Erreur lors de l'écriture...".

       01 a-plg-fin.
           02 line i col 2 value 'Fin du fichier...'.

       procedure division.
       open input FChauffeurs
       if FChauffeursStatus not = '00' then
           display a-error-write
       end-if

       open output FChaufNouv
       if FChaufNouvStatus not = '00' then
          display a-error-write
       end-if

       open output FAffectation
       if FAffectationStatus not = '00' then
          display a-error-write
       end-if

      *--- initialise l'index du tableau affectations ---
       move 2 to i.
       move 1 to j.
       move 1 to numAffect.
       move 1 to numChaufN.

       perform with test after until (
           fin-fichier = 1
           or FChauffeursStatus = '35'
       )
           read FChauffeurs
               at end
                   move 1 to fin-fichier
               not at end
                   display a-plg-chauffeur-data

                   move nom to nomN
                   move prenom to prenomN
                   move datePermis to datePermisN

                   write ChaufNouv
                       invalid key
                           display a-error-write
                   end-write

      *            --- soit index max, soit affectation vide ---
                   perform until (
                       j > 20
                       or numBus(j) = 0000
                   )
                       move numChaufN to numChaufA
                       move numBus(j) to numBusA
                       move dateDebAffect(j) to dateDebAffectA
                       move dateFinAffect(j) to dateFinAffectA

                       write Affectation
                           invalid key
                               display a-error-write
                       end-write

                       compute i = i + 2
                       display a-plg-affectation-numAffect
                       compute i = i + 1
                       display a-plg-affectation-numBus
                       compute numAffect = numAffect + 1
                       compute i = i + 1
                       display a-plg-affectation-dateDebAffect
                       compute i = i + 1
                       display a-plg-affectation-dateFinAffect

                       compute j = j + 1
                   end-perform
      *            --- incrémente la clef primaire chauffeurs ---
                   compute numChaufN = numChaufN + 1
      *            --- demande à l'utilisateur d'intervenir ---
                   stop ' '
      *            --- Nettoie l'écran ---
                   display a-blank-screen
      *            --- affiche le chauffeur en haut ---
                   move 2 to i
                   move 1 to j
           end-read
       end-perform

       display FChaufNouvStatus
       display FAffectationStatus

       close FChauffeurs.

       end program parser.
