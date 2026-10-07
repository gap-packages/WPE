This file describes changes in the WPE package.

## Unreleased

- Re-enable the efficient membership test `in` for wreath products, now
  without the recursion depth trap
- Fix the membership test for wreath products with trivial top group

## 0.8 (2024-10-21)

- Fix recursion depth trap in `ListWreathProductElement` and
  `WreathProductElementList` by disabling the package's membership test `in`
  for now

## 0.7 (2024-10-16)

- Update URLs after transfer of the repository
- Add missing reference to the manual

## 0.6 (2024-10-09)

- Require GAP >= 4.13
- Add `CycleIndex` methods for wreath products, together with
  `CycleIndexWreathProductImprimitiveAction` and the user function
  `GenericWreathProduct`
- Rename `IsomorphismToGenericWreathProduct` to `IsomorphismWreathProduct`
- Fix `Centraliser` not being used for generic wreath products and failing
  due to a wrong call of `WreathProductElementListNC`
- Fix `RepresentativeAction` and `Centraliser` raising an error when called
  with points that are not elements, e.g. subgroups
- Revise the manual, with new tutorials and a separate notation chapter

## 0.5 (2022-06-17)

- Add `CycleIndexWreathProductProductAction`

## 0.4 (2022-05-06)

- Add new `View`, `Print` and `Display` methods for wreath product elements,
  with display options configurable via
  `SetDisplayOptionsForWreathProductElements`
- Rename `SparseWreathCycleDecomposition` to `SparseWreathCycleConjugate`
- `Territory` now returns a set
- Overhaul the manual and add a tutorial chapter

## 0.3 (2022-01-04)

- Rename functions with suffix `GenericWreathProduct` to `WreathProduct`,
  e.g. `ComponentsOfWreathProduct`
- Fix an error for wreath products with trivial top group
- Rework the manual

## 0.2 (2021-11-05)

- Rename package from WreathProductElements to WPE
- Require GAP >= 4.12
- Add efficient methods for `in`, `RepresentativeAction`, `Centraliser` and
  `ConjugacyClasses` for wreath products
- Add vertical printing of wreath product elements
- Fix wrong wreath cycle decomposition

## 0.1 (2021-05-25)

- Initial release
