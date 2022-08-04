<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile doxygen_version="1.9.1">
  <compound kind="file">
    <name>README.md</name>
    <path>/__w/molpro-plugin/molpro-plugin/</path>
    <filename>README_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>PluginGuest.cpp</name>
    <path>/__w/molpro-plugin/molpro-plugin/src/molpro/</path>
    <filename>PluginGuest_8cpp.html</filename>
    <includes id="PluginGuest_8h" name="PluginGuest.h" local="yes" imported="no">PluginGuest.h</includes>
    <member kind="function">
      <type>void</type>
      <name>PluginGuestOpen</name>
      <anchorfile>PluginGuest_8cpp.html</anchorfile>
      <anchor>aa96f6cec54bbb60f0e660126a0fdc082</anchor>
      <arglist>(const char *host)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>PluginGuestActive</name>
      <anchorfile>PluginGuest_8cpp.html</anchorfile>
      <anchor>a3e6df95ddd692a04b1e756c38a647375</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>PluginGuestSend</name>
      <anchorfile>PluginGuest_8cpp.html</anchorfile>
      <anchor>a041fe7d9ef59899da88091025b638fa8</anchor>
      <arglist>(const char *value)</arglist>
    </member>
    <member kind="function">
      <type>const char *</type>
      <name>PluginGuestReceive</name>
      <anchorfile>PluginGuest_8cpp.html</anchorfile>
      <anchor>ab60db6fc4492da1c455c69d9dc4f82d7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>PluginGuestClose</name>
      <anchorfile>PluginGuest_8cpp.html</anchorfile>
      <anchor>a1be75b308025cfe2ff955a03332c7a3b</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>PluginGuest.h</name>
    <path>/__w/molpro-plugin/molpro-plugin/src/molpro/</path>
    <filename>PluginGuest_8h.html</filename>
    <class kind="class">molpro::PluginGuest</class>
    <namespace>molpro</namespace>
    <member kind="function">
      <type>void</type>
      <name>PluginGuestOpen</name>
      <anchorfile>PluginGuest_8h.html</anchorfile>
      <anchor>aa96f6cec54bbb60f0e660126a0fdc082</anchor>
      <arglist>(const char *host)</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>PluginGuestActive</name>
      <anchorfile>PluginGuest_8h.html</anchorfile>
      <anchor>a3e6df95ddd692a04b1e756c38a647375</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>PluginGuestSend</name>
      <anchorfile>PluginGuest_8h.html</anchorfile>
      <anchor>a041fe7d9ef59899da88091025b638fa8</anchor>
      <arglist>(const char *value)</arglist>
    </member>
    <member kind="function">
      <type>const char *</type>
      <name>PluginGuestReceive</name>
      <anchorfile>PluginGuest_8h.html</anchorfile>
      <anchor>ab60db6fc4492da1c455c69d9dc4f82d7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>PluginGuestClose</name>
      <anchorfile>PluginGuest_8h.html</anchorfile>
      <anchor>a1be75b308025cfe2ff955a03332c7a3b</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>PluginGuestF.F90</name>
    <path>/__w/molpro-plugin/molpro-plugin/src/molpro/</path>
    <filename>PluginGuestF_8F90.html</filename>
    <namespace>pluginguestf</namespace>
    <member kind="function">
      <type>subroutine, public</type>
      <name>pluginguestf_open</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>abe43fdd22cbc36001192ef36de358f4b</anchor>
      <arglist>(host, world)</arglist>
    </member>
    <member kind="function">
      <type>logical function, public</type>
      <name>pluginguestf_active</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>a77ee1394b16ef31d7f954b8244686bc6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>character(len=:) function, allocatable, public</type>
      <name>pluginguestf_receive</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>aedc05320b26eb61b4264bc3ad527a7a9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>logical function, public</type>
      <name>pluginguestf_send</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>a46beddee5cc050d8b3e46a9e3d311109</anchor>
      <arglist>(value)</arglist>
    </member>
    <member kind="function">
      <type>subroutine, public</type>
      <name>pluginguestf_close</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>add3471fdc1764e1944f1d47ea184aee3</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>molpro::PluginGuest</name>
    <filename>classmolpro_1_1PluginGuest.html</filename>
    <member kind="function">
      <type></type>
      <name>PluginGuest</name>
      <anchorfile>classmolpro_1_1PluginGuest.html</anchorfile>
      <anchor>a1ea21de1ded9f5941a9b6eaf3c6203f9</anchor>
      <arglist>(const std::string host=&quot;&quot;, const MPI_Comm world=MPI_COMM_WORLD)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~PluginGuest</name>
      <anchorfile>classmolpro_1_1PluginGuest.html</anchorfile>
      <anchor>a3959850ab3c96a89a9b8b09072595813</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>active</name>
      <anchorfile>classmolpro_1_1PluginGuest.html</anchorfile>
      <anchor>aef414e3cc7e89c316c301834f48a14e4</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>receive</name>
      <anchorfile>classmolpro_1_1PluginGuest.html</anchorfile>
      <anchor>a4c50ac72bd20a63bcbe5a93cc1bc5979</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>send</name>
      <anchorfile>classmolpro_1_1PluginGuest.html</anchorfile>
      <anchor>a02eb44534edc038d337adfcffdc99649</anchor>
      <arglist>(const std::string value) const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>close</name>
      <anchorfile>classmolpro_1_1PluginGuest.html</anchorfile>
      <anchor>ae3d21358558716e164438213aa98d426</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>molpro</name>
    <filename>namespacemolpro.html</filename>
    <class kind="class">molpro::PluginGuest</class>
  </compound>
  <compound kind="namespace">
    <name>pluginguestf</name>
    <filename>namespacepluginguestf.html</filename>
    <member kind="function">
      <type>subroutine, public</type>
      <name>pluginguestf_open</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>abe43fdd22cbc36001192ef36de358f4b</anchor>
      <arglist>(host, world)</arglist>
    </member>
    <member kind="function">
      <type>logical function, public</type>
      <name>pluginguestf_active</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>a77ee1394b16ef31d7f954b8244686bc6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>character(len=:) function, allocatable, public</type>
      <name>pluginguestf_receive</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>aedc05320b26eb61b4264bc3ad527a7a9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>logical function, public</type>
      <name>pluginguestf_send</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>a46beddee5cc050d8b3e46a9e3d311109</anchor>
      <arglist>(value)</arglist>
    </member>
    <member kind="function">
      <type>subroutine, public</type>
      <name>pluginguestf_close</name>
      <anchorfile>namespacepluginguestf.html</anchorfile>
      <anchor>add3471fdc1764e1944f1d47ea184aee3</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="page">
    <name>index</name>
    <title>molpro-plugin</title>
    <filename>index.html</filename>
    <docanchor file="index.html">md____w_molpro_plugin_molpro_plugin_README</docanchor>
  </compound>
</tagfile>
