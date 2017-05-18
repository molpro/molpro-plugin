#include <mpi.h>
#include <iostream>
#include <vector>
#include <unistd.h>
#include <numeric>
#include <string.h>
#include <iostream>
#include <fstream>
#include <stdexcept>

#ifndef MAXPATHLEN
#define MAXPATHLEN 1024
#endif

extern "C" void plugin_execute_c(const char* cmd, int procs=-1, int verbose=0);

int main(int argc, char *argv[])
{
  std::cout << "Plugin Host" << std::endl;
  MPI_Init(&argc,&argv);
  plugin_execute_c("./plugin-example-1",-1,1);
  plugin_execute_c("./plugin-example-3",2,1);
  plugin_execute_c("./plugin-example-2",-1,1);
  MPI_Finalize();
  return 0;
}

void plugin_execute_c(const char *cmd, int procs, int verbose)
{
  char plugin_stdout[]="plugin.out";

  int length;
  int mpimaster=0;

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  verbose = verbose && rank==0;
  if (procs < 0) // signalling default
    MPI_Comm_size(MPI_COMM_WORLD,&procs);
  if (rank==mpimaster) printf("Launch plugin %s on %d processors\n",cmd,procs);
  char* argv[1]; argv[0]=0;
  MPI_Comm intercomm;
  MPI_Info info;
  MPI_Info_create(&info);
  char wd[MAXPATHLEN];
  getcwd(wd,MAXPATHLEN);
  MPI_Info_set(info,"wdir",wd);
  std::vector<int> errors(0,procs);
  MPI_Comm_spawn(const_cast<char*>(cmd) ,argv
                 ,procs,info,mpimaster,MPI_COMM_WORLD,
                 &intercomm,&errors[0]);
  if (std::accumulate(errors.begin(),errors.end(),0)) {
      throw std::runtime_error(std::string("Error in launching plugin ")+std::string(cmd));
    }

  MPI_Comm_rank(intercomm,&rank);
  if (rank==mpimaster) {
      // identify myself
      char* id = (char*) malloc(strlen("MOLPRO")+6+strlen(plugin_stdout)+1);
      sprintf(id,"MOLPRO %4.0f %s",9999.1,plugin_stdout);
      length=strlen(id)+1;
      MPI_Send(&length,1,MPI_INT,0,0,intercomm);
      MPI_Send(id,length,MPI_CHAR,0,1,intercomm);
      free(id);
    }

  while (1) { // wait for commands from plugin
      MPI_Status status;
      useconds_t sleepinterval=20000;
      if (rank==mpimaster) {
          for ( int flag=0; ! flag; MPI_Iprobe(0,0,intercomm,&flag,&status))
            usleep(sleepinterval); // do this to stop chewing CPU cycles
          MPI_Recv(&length,1,MPI_INT,0,0,intercomm,&status);
          int response=1;
          if (length) MPI_Send(&response,1,MPI_INT,0,0,intercomm); // say 'yes please'
          MPI_Comm_size(MPI_COMM_WORLD,&procs);
          for (int i=0; i<procs; i++) { // although this is really a broadcast
              // it is done with separate messages so that
              // the slaves can probe/sleep
              if (i != mpimaster)
                MPI_Send(&length,1,MPI_INT,i,0,MPI_COMM_WORLD);
            }
        } else {
          for ( int flag=0; ! flag; MPI_Iprobe(0,0,MPI_COMM_WORLD,&flag,&status))
            usleep(sleepinterval); // do this to stop chewing CPU cycles
          MPI_Recv(&length,1,MPI_INT,0,0,MPI_COMM_WORLD,&status);
        }
      // MPI_Bcast(&length,1,MPI_INT,mpimaster,MPI_COMM_WORLD);
      // printf("Received handshake %d\n",length); fflush(stdout);
      if (length<1) break;
      char* buffer = (char*)malloc((size_t)length+1);
      if (rank==mpimaster) MPI_Recv(buffer,length,MPI_CHAR,0,1,intercomm,&status);
      MPI_Bcast(buffer,length,MPI_CHAR,mpimaster,MPI_COMM_WORLD);
      buffer[length]=0;
      if (verbose) printf("Plugin manager received command %s\n",strndup(buffer,length));
      if (!strncmp(buffer,"GIVE OPERATOR HAMILTONIAN FCIDUMP",33)) {
          if (rank==mpimaster) {
              const char filename[]="plugin.dat";
              {
                std::ofstream fcidump(filename);
                fcidump << "&FCI NORB=  5,NELEC=  2,MS2= 0,"<<std::endl;
                fcidump << "ORBSYM=1,1,2,3,5,"<<std::endl;
                fcidump << "ISYM=1,"<<std::endl;
                fcidump << "/"<<std::endl;
              }
              length=strlen(filename)+1;
              MPI_Send(&length,1,MPI_INT,0,0,intercomm);
              MPI_Send(const_cast<char*>(filename),length,MPI_CHAR,0,1,intercomm);
            }
        }
      else if (!strncmp(buffer,"GIVE INPUT",10)) {
          if (rank==mpimaster) {
              const char filename[]="plugin.dat";
              {
                std::ofstream fcidump(filename);
                fcidump << "hello"<<std::endl;
              }
              length=strlen(filename)+1;
              MPI_Send(&length,1,MPI_INT,0,0,intercomm);
              MPI_Send(const_cast<char*>(filename),length,MPI_CHAR,0,1,intercomm);
            }
        }
      else if (!strncmp(buffer,"TAKE PROPERTY",13)) {
        int prop=14; while (buffer[prop]==' ') prop++;
        fflush(stdout);
        if (rank==mpimaster) {
          MPI_Recv(&length,1,MPI_INT,0,0,intercomm,&status);
          int response=1;
          MPI_Send(&response,1,MPI_INT,0,0,intercomm); //say 'yes' or 'no'
          if (response) {
            std::string bufn(' ',length);
            MPI_Recv(&bufn[0],length,MPI_CHAR,0,1,intercomm,&status);
            std::cout << "Received property "<<bufn<<std::endl;
            }
          }
        }
      else if (!strncmp(buffer,"TAKE DENSITY FCIDUMP",20)) {
        if (rank==mpimaster)
          MPI_Recv(&length,1,MPI_INT,0,0,intercomm,&status);
        MPI_Bcast(&length,1,MPI_INT,mpimaster,MPI_COMM_WORLD);
        int response = 1;
        std::string result(' ',length);
        if (rank==mpimaster) {
          MPI_Send(&response,1,MPI_INT,0,0,intercomm); //say 'yes' or 'no'
          if (response) MPI_Recv(&result[0],length,MPI_CHAR,0,1,intercomm,&status);
        }
        if (verbose) printf("received reference to an FCIDUMP in %s\n",result.c_str());
      }
      else {
        char buf[1024];
        sprintf(buf,"Ignoring unknown plugin command: %s",buffer);
        length=0; // signal failure as a refusal
        if (rank==mpimaster) MPI_Send(&length,1,MPI_INT,0,0,intercomm);
      }
      free(buffer);
    }
  if (rank==mpimaster) printf("Plugin %s has finished\n",cmd);
}
