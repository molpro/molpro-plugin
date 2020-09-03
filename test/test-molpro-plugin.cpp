#include <gtest/gtest.h>

#ifdef HAVE_MPI
#include <mpi.h>
int main(int argc, char *argv[]) {
  int result = 0;

  ::testing::InitGoogleTest(&argc, argv);
  MPI_Init(&argc, &argv);
  result = RUN_ALL_TESTS();
  MPI_Finalize();

  return result;
}
#endif

#include <molpro/PluginGuest.h>

TEST(molpro_plugin, basic) {
  molpro::PluginGuest tester;
#ifdef HAVE_MPI
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
#endif
}

