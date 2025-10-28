#!/bin/bash

echo "🚀 CI/CD Cluster Verification"
echo "============================"

# Test basic connectivity
echo -n "Testing SSH connectivity: "
ssh -o StrictHostKeyChecking=no -i /tmp/ssh_key clusteradmin@head "echo 'Head OK'" && echo "✓" || echo "✗"

echo -n "Testing com2 accessibility: "
ssh -o StrictHostKeyChecking=no -i /tmp/ssh_key clusteradmin@head "ssh com2 echo 'com2 OK'" && echo "✓" || echo "✗"

echo -n "Testing NFS mount: "
ssh -o StrictHostKeyChecking=no -i /tmp/ssh_key clusteradmin@head "echo 'CI Test' > /home/clusteradmin/ci_test.txt && echo 'Write ✓'" && echo "✓" || echo "✗"

echo -n "Testing NFS read from com2: "
ssh -o StrictHostKeyChecking=no -i /tmp/ssh_key clusteradmin@com2 "cat /home/clusteradmin/ci_test.txt" >/dev/null && echo "✓" || echo "✗"

# Cleanup
ssh -o StrictHostKeyChecking=no -i /tmp/ssh_key clusteradmin@head "rm -f /home/clusteradmin/ci_test.txt" 2>/dev/null || true

echo
echo "✅ CI/CD Verification Complete"
