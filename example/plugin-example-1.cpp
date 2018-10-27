#include "mpi.h"
#include <PluginGuest.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <stdio.h>
#include <FCIdump.h>
#include <vector>
#include <stdexcept>
#include <iostream>

int main(int argc, char *argv[])
{
  MPI_Init(&argc, &argv);

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);

  {
  PluginGuest molproPlugin; // the constructor attempts to establish communication

  if (rank==0) {
    if (! molproPlugin.active())
      printf("Not running in plugin mode\n"); // or stay silent
    else
      printf("Molpro plugin has been initialised\n");
  }

  std::string fcidumpname;
  if (molproPlugin.active()) {
    // ask for an FCIDUMP
    molproPlugin.send("GIVE OPERATOR HAMILTONIAN FCIDUMP");
    fcidumpname = molproPlugin.receive();
    if (rank == 0) {
      FCIdump d(fcidumpname);
      int norb = d.parameter("NORB",std::vector<int>(0))[0];
      int nelec = d.parameter("NELEC",std::vector<int>(0))[0];
      int ms2 = d.parameter("MS2",std::vector<int>(0))[0];
      printf("%d orbitals, %d electrons, spin multiplicity %d\n",norb,nelec,ms2+1);
      d.rewind();
      int i,j,k,l; double value;
      while(d.nextIntegral(i,j,k,l,value)!=FCIdump::endOfFile)
	printf("Integral %d %d %d %d %f\n",i,j,k,l,value);
    }
  }

  // do the main work here
  // sleep(30);
  // ....

    // send the energy back (just made up for this demonstration)
  if (1) {
    molproPlugin.send("TAKE PROPERTY ENERGY");
    if (!molproPlugin.send("12345.0 56789.0"))
      printf("Warning: could not send energy\n");
  }

    // send the density back as a reference to an FCIDUMP (in this demonstration, send the hamiltonian instead)
    molproPlugin.send("TAKE DENSITY FCIDUMP");
    char dir[1024];
    char pid[9];
    sprintf(pid,"%08d",(int)getpid());
    std::string filename=std::string(getcwd(dir,1024)) + "/"+std::string(pid);
    if (!molproPlugin.send(filename))
      printf("Warning: could not send density filename\n");
    if (rank==0)
    {
      FCIdump d(fcidumpname);
      // fill values in to d here
      d.write(filename);
    }

  } // molproPlugin destroyed by going out of context causes signal to Molpro plugin server that we are finished
  // or one can explicitly call molproPlugin.close();

  if (rank==0) printf("Plugin finishing\n");
  fflush(stdout);
  MPI_Finalize();
  return 0;
}
