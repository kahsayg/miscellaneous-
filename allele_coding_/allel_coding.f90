!**************************************
! This is a program  to change SNPs allele codes 
! from 2010 1 2 to 
!      2010 1
!      2010 2
! required parameters are number of aniamls, 
! total number of SNPS Locus, Number of alleles per Locus
! if there are two allels per SNPs locus  the number 
! of locus is half the total number of alleles
! Kahsay Nirea March 26,2013, 10:06 AM  
!**************************************


program change_allel_code  
integer,parameter:: nanim=10,nloc=5,nall=2
integer::allel(nloc,nall),id(nanim)


 open(10,file='input_filename',status='old') 
 open(11,file='output_filename',status='unknown') 
     
     do i=1,nanim 
        read(10,*)id(i),((allel(j,k),k=1,nall),j=1,nloc) 
        write(11,'(i10,100i2)') id(i),allel(1:nloc,1)
        write(11,'(i10,100i2)') id(i),allel(1:nloc,2)
    end do 

end program change_allel_code
       
       
  
 

 
