PROGRAM plugin_example_2
 USE PluginGuestF
 USE FCIdumpF
 USE iso_fortran_env
 IMPLICIT NONE
#include "mpif.h"
 CHARACTER(1024) :: fcidumpname, filename, datafilename
 INTEGER :: size
 INTEGER :: rank
 INTEGER :: ierr
 CHARACTER(1024) :: id
 INTEGER length
 INTEGER :: norb, nelec, ms2
 INTEGER, DIMENSION(1) :: ivals
 INTEGER :: i,j,k,l
 DOUBLE PRECISION :: value

 CALL MPI_Init(ierr)
 CALL MPI_Comm_size(MPI_COMM_WORLD, size, ierr)
 CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

! is this a Molpro plugin?
 CALL PluginGuestF_open('MOLPRO')

 IF (.NOT. PluginGuestF_active()) THEN
  IF (rank.EQ.0) PRINT '(''Not running in plugin mode'')' ! or stay silent
 END IF

 IF (PluginGuestF_active() .AND. rank.EQ.0) THEN
! ask for an FCIDUMP
  IF (.NOT. PluginGuestF_send('GIVE OPERATOR HAMILTONIAN FCIDUMP')) CALL Terminate( &
  'Unexpected refusal of plugin server to receive command')
  fcidumpname=PluginGuestF_receive()
  CALL FCIdumpFInitialise(fcidumpname)
  CALL FCIdumpFParameterI("NORB",ivals); norb=ivals(1)
  CALL FCIdumpFParameterI("NELEC",ivals); ms2=ivals(1)
  CALL FcidumpFParameterI("MS2",ivals); ms2=ivals(1)
  WRITE (output_unit, '(I3,'' orbitals, '',I3,'' electrons, spin multiplicity '',I3)') norb,nelec,ms2+1
  CALL FCIdumpFRewind()
  DO WHILE (FCIdumpFNextIntegral(i,j,k,l,value) .NE. 6)
   WRITE (output_unit, '(''Integral '',I3,'' '',I3,'' '',I3,'' '',I3,'' '',F15.8)') i,j,k,l,value
  END DO
 END IF

 IF (PluginGuestF_active() .AND. rank.EQ.0) THEN
! ask for a data file
  IF (.NOT. PluginGuestF_send('GIVE INPUT NECI')) CALL Terminate( &
  'Unexpected refusal of plugin server to receive command')
  datafilename=PluginGuestF_receive()
  WRITE (output_unit, '(''Input file: '',A/)') TRIM(datafilename)
  OPEN(1,file=datafilename,status='OLD')
  DO WHILE (.TRUE.)
   READ(1,'(A)',END=99) id
   WRITE (output_unit, '(A)') TRIM(id)
  END DO
99 CLOSE(1)
 END IF


! do the main work here
! ....

 IF (PluginGuestF_active() .AND. rank.EQ.0) THEN
! offer to send the energy back (just made up for this demonstration)
  IF (.NOT. PluginGuestF_send('TAKE PROPERTY ENERGY')) CALL Terminate( &
  'Unexpected refusal of plugin server to receive command')
  IF (.NOT. PluginGuestF_send('12345.0 6789.0')) WRITE (output_unit,*) 'attempt to send energy has failed'
 END IF

 IF (PluginGuestF_active() .AND. rank.EQ.0) THEN
! offer to send the density back as a reference to an FCIDUMP (in this demonstration, send the hamiltonian instead)
  filename='density.fcidump' ! should make unique fully-qualified name
  IF (.NOT. PluginGuestF_send('TAKE DENSITY FCIDUMP')) CALL Terminate( &
  'Unexpected refusal of plugin server to receive command')
  IF (.NOT. PluginGuestF_send(filename)) THEN
   WRITE (output_unit,*) 'attempt to send density has failed'
  ELSE
   IF ( .NOT. FCIdumpFWrite(filename,3) ) WRITE (output_unit,*) 'Attempt to construct FCIdump file has failed'
  END IF
 END IF

 CALL Terminate

CONTAINS

SUBROUTINE Terminate(message)
 CHARACTER(*), INTENT(in), OPTIONAL :: message
 IF (PRESENT(message)) WRITE (output_unit,*) message
 CALL PluginGuestF_close ! signal to plugin server that we are finished
 IF (rank.EQ.0) WRITE (output_unit, '(A)') 'Plugin finishing'
 CALL MPI_Finalize(ierr)
END SUBROUTINE Terminate
END PROGRAM plugin_example_2
