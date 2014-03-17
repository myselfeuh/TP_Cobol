       file output section.
           file-control.
           select Fchauffeur assign to 'chauffeur\Fchauffeur.dat'
               organization is sequential
               status fstat

       file section.
       fd Fchauffeur.
           01 chauffeur.
               02 nom          pic x(30).
               02 prenom       pic x(30).
               02 datepermis   pic 9(8).
               02 tabaffect.
                   03 affect occurs 20.
                       04 numbus           pic 9(4).
                       04 dateDebAffect    pic 9(8).
                       04 dateFinAffect    pic 9(8).

