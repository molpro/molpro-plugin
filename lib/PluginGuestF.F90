!>\brief Supports the communication of a plugin that has been launched via MPI_Comm_spawn.
!> See the documentation of the C++ PluginGuest class.
!> Example of use: @include plugin-example-2.F90
MODULE PluginGuestF
 IMPLICIT NONE
#include "mpif.h"
 PRIVATE

 PUBLIC :: PluginGuestF_open, PluginGuestF_send, PluginGuestF_receive, PluginGuestF_active, PluginGuestF_close

 LOGICAL :: m_active !!< whether this Molpro plugin framework is active
 INTEGER :: m_rank !!< rank of process. All that matters is that one of the processes has m_rank=0
 INTEGER :: m_intercomm !!< the intercommunicator to the parent
 INTEGER :: m_world !!< the guest world communicator
 CHARACTER(:), ALLOCATABLE :: m_host !!< the name of the host program
 CHARACTER(:), ALLOCATABLE :: m_hostVersion !!< the version of the host program

CONTAINS

 SUBROUTINE PluginGuestF_open(host,world)
  USE iso_fortran_env, ONLY : output_unit
  IMPLICIT NONE
  CHARACTER(*), INTENT(in), OPTIONAL :: host !< The required host program name (default: no requirement)
  INTEGER, INTENT(in), OPTIONAL :: world !< The MPI communicator for all participating processes (default MPI_COMM_WORLD)
  INTEGER :: size
  INTEGER :: ierr
  CHARACTER(1024) :: id
  INTEGER :: length
  INTEGER, DIMENSION(MPI_Status_size) :: status
  m_active=.FALSE.
  if (present(world)) then
   m_world = world
  else
   m_world = MPI_COMM_WORLD
  end if
  CALL MPI_Comm_rank(m_world, m_rank, ierr)
  CALL MPI_Comm_get_parent(m_intercomm, ierr)
  IF (m_rank.EQ.0 .AND. m_intercomm .NE. MPI_COMM_NULL) THEN
! expect plugin server to identify itself
   CALL MPI_Recv(length,1,MPI_INT,0,0,m_intercomm,status,ierr)
   CALL MPI_Recv(id,length,MPI_CHAR,0,1,m_intercomm,status,ierr)
   id(length:)=' '
   length = INDEX(id,' ')-1
   ALLOCATE(CHARACTER(MAX(length,1)) :: m_host)
   IF (length.GT.0)  THEN
    m_host=id(:length)
    IF (PRESENT(host)) THEN
     m_active = m_host.EQ.host
    ELSE
     m_active = .TRUE.
    END IF
   ELSE
    m_host=''
   END IF
   IF (m_active) THEN
    id = ADJUSTL(id(length+1:))
    length = INDEX(id,' ')-1
    ALLOCATE(CHARACTER(MAX(length,1)) :: m_hostVersion)
    IF (length.GT.0)  THEN
     m_hostVersion=id(:length)
     id = ADJUSTL(id(length+1:))
     IF (id.NE.'') THEN
      CLOSE(output_unit)
      OPEN (output_unit,file=id,iostat=ierr)
     END IF

     CALL MPI_Comm_size(m_world, size, ierr)
     WRITE (output_unit,'(A,A,A,A,A,I4,A)') 'Plugin for ',m_host,' version ',m_hostVersion,' running with',size,' processes'
    ELSE
     m_hostVersion=''
    END IF
   END IF
  END IF
  length = len_TRIM(m_host)
  CALL MPI_Bcast(length,1,MPI_INT,0,m_world,ierr)
  IF (m_rank.NE.0) ALLOCATE(CHARACTER(MAX(length,1)) :: m_host)
  CALL MPI_Bcast(m_host,length,MPI_CHAR,0,m_world,ierr)
  length = len_TRIM(m_hostVersion)
  CALL MPI_Bcast(length,1,MPI_INT,0,m_world,ierr)
  IF (m_rank.NE.0) ALLOCATE(CHARACTER(MAX(length,1)) :: m_hostVersion)
  CALL MPI_Bcast(m_hostVersion,length,MPI_CHAR,0,m_world,ierr)
  CALL MPI_Bcast(m_active,1,MPI_LOGICAL,0,m_world,ierr)
 END SUBROUTINE PluginGuestF_open

 FUNCTION PluginGuestF_active()
  IMPLICIT NONE
  LOGICAL :: PluginGuestF_active
  PluginGuestF_active = m_active
 END FUNCTION PluginGuestF_active

 FUNCTION PluginGuestF_receive()
  IMPLICIT NONE
  CHARACTER(len=:), ALLOCATABLE :: PluginGuestF_receive
  INTEGER, DIMENSION(MPI_Status_size) :: status
  INTEGER :: ierr
  INTEGER :: length
  IF (m_rank.EQ.0) CALL MPI_Recv(length,1,MPI_INT,0,0,m_intercomm,status,ierr)
  CALL MPI_Bcast(length,1,MPI_INT,0,m_world,ierr)
  ALLOCATE(CHARACTER(length) :: PluginGuestF_receive)
  IF (m_rank.EQ.0) CALL MPI_Recv(PluginGuestF_receive,length,MPI_INT,0,1,m_intercomm,status,ierr)
  CALL MPI_Bcast(PluginGuestF_receive,length,MPI_CHAR,0,m_world,ierr)
 END FUNCTION PluginGuestF_receive

 FUNCTION PluginGuestF_send(value)
  USE iso_c_binding, ONLY : c_null_char
  IMPLICIT NONE
  LOGICAL :: PluginGuestF_send
  CHARACTER(*), INTENT(in) :: value
  INTEGER :: length, answer, ierr
  INTEGER, DIMENSION(MPI_Status_size) :: status
  PluginGuestF_send=.TRUE.
  IF (.NOT. m_active) RETURN
  length=len_TRIM(value)!+1
  CALL MPI_Bcast(length,1,MPI_INT,0,m_world,ierr)
  IF (m_rank.EQ.0) CALL MPI_Send(length,1,MPI_INT,0,0,m_intercomm,ierr)
  IF (length.LE.0) RETURN
  IF (m_rank.EQ.0) CALL MPI_Recv(answer,1,MPI_INT,0,0,m_intercomm,status,ierr)
  CALL MPI_Bcast(answer,1,MPI_INT,0,m_world,ierr)
  IF (answer.EQ.0) THEN
   PluginGuestF_send=.FALSE.
  ELSE
   IF (m_rank.EQ.0) CALL MPI_Send(TRIM(value),length,MPI_CHAR,0,1,m_intercomm,ierr)
  END IF

 END FUNCTION PluginGuestF_send

 SUBROUTINE PluginGuestF_close
  USE iso_fortran_env, ONLY : output_unit
  IMPLICIT NONE
  FLUSH(output_unit)
  IF (.NOT.PluginGuestF_send('')) WRITE (output_unit,*) 'problem in closing plugin guest'
  IF (ALLOCATED(m_host)) DEALLOCATE(m_host)
  IF (ALLOCATED(m_hostVersion)) DEALLOCATE(m_hostVersion)
  m_active = .FALSE.
 END SUBROUTINE PluginGuestF_close

END MODULE PluginGuestF
