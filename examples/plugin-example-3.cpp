#include "mpi.h"
#include <molpro/PluginGuest.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  MPI_Init(&argc, &argv);

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);

  PluginGuestOpen("MOLPRO");

  if (rank==0) {
    if (! PluginGuestActive())
      printf("Not running in plugin mode\n"); // or stay silent
    else
      printf("Molpro plugin has been initialised\n");
  }

  const char* fcidumpname;
  if (PluginGuestActive()) {
    // ask for an FCIDUMP
    PluginGuestSend("GIVE OPERATOR HAMILTONIAN FCIDUMP");
    fcidumpname = PluginGuestReceive();
    if (rank==0)
      printf("Obtained reference to hamiltonian FCIdump: %s\n",fcidumpname);
  }

  // do the main work here
  // sleep(30);
  // ....

  // send the energy back (just made up for this demonstration)
  if (1) {
    PluginGuestSend("TAKE PROPERTY ENERGY");
    if (!PluginGuestSend("12345.0 56789.0"))
      printf("Warning: could not send energy\n");
  }

  PluginGuestClose();

  if (rank==0)
    printf("Plugin finishing\n");
  fflush(stdout);
  MPI_Finalize();
  return 0;
}
