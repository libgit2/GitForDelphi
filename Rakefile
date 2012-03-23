task :clean do
   sh "rm -f *.dcu tests/*.dcu tests/*.exe tests/*.identcache tests/*.local tests/TestsFromLibGit2/*.dcu "
end

task :binary do
   if !ENV['msg']
      puts "Please pass in a msg: rake binary msg=\"commit message\""
      exit
   end
   
   ENV['GIT_INDEX_FILE'] = '.git/i'

   `git hash-object -w README.md`
   `git hash-object -w tests/git2.dll`
   `git reset binary README.md`
   `git add -f tests/git2.dll`
   tsha = `git write-tree`
   csha = `echo #{ENV['msg']} | git commit-tree #{tsha}`
   `git update-ref refs/heads/binary #{csha.strip} `

   ENV['GIT_INDEX_FILE'] = ''
   `rm .git/i `
end

