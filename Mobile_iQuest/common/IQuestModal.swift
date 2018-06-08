//
//  IquestModal.swift
//  Mobile_iQuest
//
//  Created by Anand Kumar on 02/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

class IQuestModal: NSObject{
    var _endpointType: String = ""
    var _token = TokenModal()
    var _projectList = PojectListModal()
    var endpointType: String{
        get{
            return _endpointType
            
        }
        set{
            
        }
    }
    var token: TokenModal{
        get{
            return _token
        }
        set{
            
        }
    }
    
    var projectList: PojectListModal{
        get{
            return _projectList
        }
        set{

        }
    }

    
}


