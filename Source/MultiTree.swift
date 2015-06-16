/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*
* MultiTree
*
* A powerful data structure that is backed by a RedBlackTree using an order
* statistic. This allows for manipulation and access of the data as if an array,
* while maintaining log(n) performance on all operations. Items in a MultiTree
* may not be uniquely keyed.
*/

public class MultiTree<K: Comparable, V> {
	private typealias MultiTreeNode = RedBlackNode<K, V>
	
	/**
	* tree
	* Underlying data structure.
	*/
	internal var tree: RedBlackTree<K, V>
	
	/**
	* count
	* Number of nodes in the MultiTree.
	*/
	public var count: Int {
		return tree.count
	}
	
	/**
	* last
	* Last node in the tree based on the key ordering.
	*/
	public var last: V? {
		return tree.last
	}
	
	/**
	* first
	* First node in the tree based on the key ordering.
	*/
	public var first: V? {
		return tree.first
	}
	
	/**
	* empty
	* A boolean of whether the MultiTree is empty.
	*/
	public var empty: Bool {
		return tree.empty
	}
	
	/**
	* init
	* Constructor.
	*/
	public init() {
		tree = RedBlackTree<K, V>(unique: false)
	}
	
	/**
	* insert
	* Insert a new node into the MultiTree.
	* @param		key: K
	* @param		value: V?
	* @return		Bool of the result. True if inserted, false otherwise.
	*				Failure of insertion would mean the key already
	*				exists in the MultiTree.
	*/
	public func insert(key: K, value: V?) -> Bool {
		return tree.insert(key, value: value)
	}
	
	/**
	* remove
	* Remove a node from the MultiTree by the key value.
	* @param		key: K
	* @return		Bool of the result. True if removed, false otherwise.
	*/
	public func remove(key: K) -> Bool {
		return tree.remove(key)
	}
	
	/**
	* update
	* Updates a node for the given key value.
	* @param		key: K
	* @param		value: V?
	* @return		A boolean value of the result.
	*/
	public func update(key: K, value: V?) -> Bool {
		return tree.update(key, value: value)
	}
	
	/**
	* find
	* Finds a node by its key value and returns the
	* data that the node points to.
	* @param		key: K
	* @return		value V?
	*/
	public func find(key: K) -> V? {
		return tree.find(key)
	}
	
	/**
	* operator [0...count - 1]
	* Allos array like access of the index.
	* Items are kept in order, so when iterating
	* through the items, they are returned in their
	* ordered form.
	* @param		index: Int
	* @return		value V?
	*/
	public subscript(index: Int) -> V? {
		get {
			return tree[index]
		}
		set(value) {
			tree[index] = value
		}
	}
	
	/**
	* operator ["key 1"..."key 2"]
	* Property key mapping. If the key type is a
	* String, this feature allows access like a
	* Dictionary.
	* @param		name: String
	* @return		value V?
	*/
	public subscript(name: String) -> V? {
		get {
			return tree[name]
		}
		set(value) {
			tree[name] = value
		}
	}
	
	/**
	* search
	* Accepts a paramter list of keys and returns a subset
	* MultiTree with the indicated values if
	* they exist.
	* @param		keys: K...
	* @return		MultiTree subset.
	*/
	public func search(keys: K...) -> MultiTree {
		return search(keys)
	}
	
	/**
	* search
	* Accepts an array of keys and returns a subset
	* MultiTree with the indicated values if
	* they exist.
	* @param		keys: K...
	* @return		MultiTree subset.
	*/
	public func search(array: Array<K>) -> MultiTree {
		var s: MultiTree<K, V> = MultiTree<K, V>()
		for key: K in array {
			tree.subset(key, node: tree.root, set: &s.tree)
		}
		return s
	}
	
	/**
	* clear
	* Removes all nodes in the MultiTree.
	*/
	public func clear() {
		tree.clear()
	}
}

extension MultiTree: Printable {
	/**
	* description
	* Conforms to the Printable Protocol. Outputs the
	* data in the MultiTree in a readable format.
	*/
	public var description: String {
		return "MultiTree" + tree.description
	}
}

extension MultiTree: SequenceType {
	private typealias Generator = GeneratorOf<V?>
	
	/**
	* generate
	* Conforms to the SequenceType Protocol. Returns
	* the next value in the sequence of nodes using
	* index values [0...n-1].
	*/
	public func generate() -> Generator {
		var index = 0
		return GeneratorOf {
			if index < self.count {
				return self.tree[index++]
			}
			return nil
		}
	}
}