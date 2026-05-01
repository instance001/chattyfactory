Title: build a file sorting tool
Project: build_a_file_sorting_tool_7
Anchor: scratch

- [ ] Create main.go | echo 'package main\n\nimport (\n\t"fmt"\n\t"os"\n\t"path/filepath"\n)\n\nfunc main() {\n\tif len(os.Args) < 2 {\n\t\tfmt.Println("Usage: file_sorter <directory>")\n\t\treturn\n\t}\n\troot := os.Args[1]\n\tfiles, err := filepath.Glob(filepath.Join(root, "*"))\n\tif err != nil { fmt.Println(err); return }\n\tfor _, f := range files {\n\t\tfmt.Println(f)\n\t}\n}' > scratch/main.go | verify: exists scratch/main.go
- [ ] Add sorting logic in utils/sort.go | echo 'package utils\n\nimport (\n\t"os"\n\t"path/filepath"\n)\n\nfunc SortFiles(root string) ([]string, error) {\n\treturn filepath.Glob(filepath.Join(root, "*"))\n}' > scratch/utils/sort.go | verify: exists scratch/utils/sort.go
- [ ] Write tests in main_test.go | echo 'package main\n\nimport (\n\t"testing"\n)\n\nfunc TestSortFiles(t *testing.T) {\n\tfiles, err := utils.SortFiles(".")\n\tif err != nil { t.Fatal(err) }\n\tif len(files) == 0 { t.Error("expected files") }\n}' > scratch/main_test.go | verify: exists scratch/main_test.go
- [ ] Run tests | go test ./... | verify: output contains PASS
- [ ] Build binary | go build -o file_sorter . | verify: exists scratch/file_sorter