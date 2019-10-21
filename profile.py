# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

#pc.defineParameter( "n", "Number of worker nodes, a number from 2 to 5", portal.ParameterType.INTEGER, 4 )
#params = pc.bindParameters()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Lists for the nodes and such
nodeList = []

tourDescription = \
"""
This profile provides the template for  blah blah installed on Ubuntu 18.04
"""

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)

prefixForIP = "192.168.1."

#maxSize = 5
#beegfnNum = params.n + 1

link = request.LAN("lan")

for i in range(2):
  if i == 0:
    node = request.XenVM("ldapserver")    
  else:
    node = request.XenVM("ldapclient")
  
  node.cores = 4
  node.ram = 4096
  
  node.routable_control_ip = "true"  
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
  
  iface = node.addInterface("if" + str(i+1))
  iface.component_id = "eth"+ str(i+1)
  iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
  link.addInterface(iface)
  
  # running scripts on associated machines 
  if i == 0:
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/ldap_install.sh"))
    node.addService(pg.Execute(shell="sh", command="/local/repository/ldap_install.sh"))
  else:
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/clientSide_ldap.sh"))
    node.addService(pg.Execute(shell="sh", command="/local/repository/clientSide_ldap.sh"))
    
  # Following 4 lines would work with ldap_install_combined.sh (lines 33-38 do the same thing)
  #node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/ldap_install_combined.sh"))
  #node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/ldap_install.sh"))
  #node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/clientSide_ldap.sh"))
  #node.addService(pg.Execute(shell="sh", command="/local/repository/ldap_install_combined.sh"))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
